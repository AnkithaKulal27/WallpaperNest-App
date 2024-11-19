import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class FullScreen extends StatelessWidget {
  String imgUrl;
  FullScreen({super.key, required this.imgUrl});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> requestStoragePermission() async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle the case where permission is denied
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text("Storage permission denied.")),
      );
      return;
    }
  }

  Future<void> setWallPaperFromFile(
      String wallpaperUrl, BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Downloading Started...")));

    try {
      // Request storage permission before downloading
      await requestStoragePermission();

      // Download and save the image to the gallery
      var imageId = await ImageDownloader.downloadImage(
        wallpaperUrl,
        destination: AndroidDestinationType.directoryPictures,
      );

      if (imageId == null) {
        return;
      }

      // Retrieve the image path
      var path = await ImageDownloader.findPath(imageId);

      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Downloaded Successfully"),
          action: SnackBarAction(
              label: "Open",
              onPressed: () {
                // Open the image in the gallery using the Android intent
                OpenFile.open(path);
              }),
        ));
      }
    } on PlatformException catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Occurred: $error")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An unexpected error occurred: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ElevatedButton(
          child:
              const Text("Set WallPaper", style: TextStyle(color: Colors.blue)),
          onPressed: () async {
            await setWallPaperFromFile(imgUrl, context);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imgUrl), fit: BoxFit.cover)),
      ),
    );
  }
}
