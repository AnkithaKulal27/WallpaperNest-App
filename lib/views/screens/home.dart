import 'package:flutter/material.dart';
import 'package:wallpaperapp/controller/apiOper.dart';
import 'package:wallpaperapp/model/photosModel.dart';
import 'package:wallpaperapp/model/categoryModel.dart';
import 'package:wallpaperapp/views/screens/fullScreen.dart';
import 'package:wallpaperapp/views/widgets/CustomAppBar.dart';
import 'package:wallpaperapp/views/widgets/catBlock.dart';
import 'package:wallpaperapp/views/widgets/SearchBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<PhotosModel> trendingWallList;
  late List<CategoryModel> catModList;
  bool isLoading = true;

  getCatDetails() async {
    catModList = await ApiOperations.getCategoriesList();
    print("GETTING CAT MOD LIST");
    print(catModList);
    setState(() {
      catModList = catModList;
    });
  }

  getTrendingWallpapers() async {
    trendingWallList = await ApiOperations.getTrendingWallpapers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCatDetails();
    getTrendingWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.white,
        title: const CustomAppBar(),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: searchBar()),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: catModList.length,
                        itemBuilder: ((context, index) => CatBlock(
                              categoryImgSrc: catModList[index].catImgUrl,
                              categoryName: catModList[index].catName,
                            ))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 700,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 400,
                            crossAxisCount: 2,
                            crossAxisSpacing: 13,
                            mainAxisSpacing: 10),
                        itemCount: trendingWallList.length,
                        itemBuilder: ((context, index) => GridTile(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullScreen(
                                              imgUrl: trendingWallList[index]
                                                  .imgSrc)));
                                },
                                child: Hero(
                                  tag: trendingWallList[index].imgSrc,
                                  child: Container(
                                    height: 800,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.amberAccent,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                          height: 800,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          trendingWallList[index].imgSrc),
                                    ),
                                  ),
                                ),
                              ),
                            ))),
                  ),
                )
              ],
            )),
    );
  }
}
