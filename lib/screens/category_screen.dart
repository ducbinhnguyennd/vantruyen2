import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/category_model.dart';
import 'package:loginapp/screens/manhinhdetail_theloai.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        title: Text('Màn hình thể loại'),
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: categoryService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorConst.colorPrimary120,
            ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final categories = snapshot.data;
            // print('object ${categories}');

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 4 / 2),
              itemCount: categories!.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MangaListScreen(category: category),
                      ),
                    );
                  },
                  child: Card(
                    color: ColorConst.colorPrimary80,
                    child: Center(
                      child: Text(category.categoryName ?? ' loi'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
