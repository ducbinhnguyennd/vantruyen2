import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/model/trangchu_model.dart';
import 'package:loginapp/widgets/item_truyenmoi.dart';

class CategoryDetailScreen extends StatelessWidget {
  final List<Manga> categoryMangas;
  final String categoryName;

  CategoryDetailScreen(
      {required this.categoryMangas, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        title: Text(categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Số cột
            childAspectRatio:
                3 / 5, // Tỷ lệ chiều rộng so với chiều cao của mỗi item
          ),
          itemCount: categoryMangas.length,
          itemBuilder: (context, index) {
            return ItemTruyenMoi(
              id: categoryMangas[index].id!,
              name: categoryMangas[index].mangaName!,
              image: categoryMangas[index].image!,
              sochap: categoryMangas[index].totalChapters.toString(),
              view: categoryMangas[index].view.toString(),
            );
          },
        ),
      ),
    );
  }
}
