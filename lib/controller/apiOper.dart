import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallpaperapp/model/photosModel.dart';
import 'package:wallpaperapp/model/categoryModel.dart';
import 'dart:math';

class ApiOperations {
  static List<PhotosModel> trendingWallpapers = [];
  static List<PhotosModel> searchWallPapersList = [];
  static List<CategoryModel> categoryModelList = [];

  static const String _apiKey =
      "6DQunTvdHJFDwFGxcKxXi8KT8FkMPmlBZmx9VQAE1DjH3ZtiFL5nFWUr";

  static get cateogryName => null;
  static Future<List<PhotosModel>> getTrendingWallpapers() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated"),
        headers: {"Authorization": "$_apiKey"}).then((value) {
      print("RESPONSE REPORT");
      print(value.body);
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      photos.forEach((element) {
        trendingWallpapers.add(PhotosModel.fromAPI2App(element));
      });
    });
    return trendingWallpapers;
  }

  static Future<List<PhotosModel>> searchWallPapers(String query) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=30&page=1"),
        headers: {"Authorization": "$_apiKey"}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      searchWallPapersList.clear();
      photos.forEach((element) {
        searchWallPapersList.add(PhotosModel.fromAPI2App(element));
      });
    });
    return searchWallPapersList;
  }

  static List<CategoryModel> getCategoriesList() {
    List categoryName = [
      "Cars",
      "Nature",
      "Bikes",
      "Street",
      "City",
      "Flowers"
    ];
    categoryModelList.clear();
    categoryName.forEach((catName) async {
      final _random = new Random();

      PhotosModel photoModel =
          (await searchWallPapers(catName))[0 + _random.nextInt(11 - 0)];
      print("IMG SRC IS HERE");
      print(photoModel.imgSrc);
      categoryModelList
          .add(CategoryModel(catImgUrl: photoModel.imgSrc, catName: catName));
    });
    return categoryModelList;
  }
}
