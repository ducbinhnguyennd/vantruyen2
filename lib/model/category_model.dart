import 'package:loginapp/model/trangchu_model.dart';

class CategoryModel {
  String? id;
  String? categoryName;
  List<Manga>? mangaList;

  CategoryModel({this.id, this.categoryName, this.mangaList});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> mangaDataList = json['manga'] ?? [];
    final List<Manga> mangaList =
        mangaDataList.map((mangaData) => Manga.fromJson(mangaData)).toList();
    return CategoryModel(
      id: json['categoryid'],
      categoryName: json['categoryname'],
      mangaList: mangaList,
    );
  }
}
