import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/trangchu_model.dart';
import 'package:loginapp/screens/detail_category_screen.dart';
import 'package:loginapp/widgets/item_to.dart';
import 'package:loginapp/widgets/item_truyenmoi.dart';

class ItemTrangChu extends StatefulWidget {
  const ItemTrangChu({Key? key});

  @override
  State<ItemTrangChu> createState() => _ItemTrangChuState();
}

class _ItemTrangChuState extends State<ItemTrangChu> {
  late Future<List<Manga>> mangaList;

  @override
  void initState() {
    super.initState();
    mangaList = MangaService.fetchMangaList();
  }

  Map<String, List<Manga>> groupMangasByCategory(List<Manga> mangas) {
    Map<String, List<Manga>> groupedMangas = {};
    for (var manga in mangas) {
      if (!groupedMangas.containsKey(manga.category)) {
        groupedMangas[manga.category!] = [];
      }
      groupedMangas[manga.category]!.add(manga);
    }
    return groupedMangas;
  }

  @override
  Widget build(BuildContext context) {
    final widthS = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Manga>>(
      future: mangaList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorConst.colorPrimary50,
                backgroundColor: ColorConst.colorPrimary80,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Kiểm tra lại kết nối internet');
        } else {
          if (snapshot.hasData) {
            List<Manga> mangas = snapshot.data!;
            Map<String, List<Manga>> groupedMangas =
                groupMangasByCategory(mangas);

            return Column(
              children: groupedMangas.entries.map((entry) {
                final category = entry.key;
                final categoryMangas = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryMangas: categoryMangas,
                                categoryName: category,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${category}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('Xem thêm')
                            ],
                          ),
                        )),
                    SizedBox(
                        child: category == 'Action'
                            ? SizedBox(
                                width: double.infinity,
                                height: 220,
                                child: GridView(
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: widthS / 1,
                                    childAspectRatio: 4 / 2.3,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                  ),
                                  children: List.generate(categoryMangas.length,
                                      (index) {
                                    return ItemTruyenMoi(
                                        id: categoryMangas[index].id!,
                                        name: categoryMangas[index].mangaName!,
                                        image: categoryMangas[index].image!,
                                        sochap: categoryMangas[index]
                                            .totalChapters
                                            .toString(),
                                        view: categoryMangas[index]
                                            .view
                                            .toString());
                                  }),
                                ),
                              )
                            : category == 'Anime'
                                ? SizedBox(
                                    width: widthS,
                                    child: GridView.builder(
                                      padding: EdgeInsets.all(0),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0,
                                        childAspectRatio:
                                            Platform.isIOS ? 3 / 5 : 3 / 4.5,
                                      ),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 6,
                                      itemBuilder: (context, innerIndex) {
                                        return ItemTruyenMoi(
                                          id: categoryMangas[innerIndex].id!,
                                          name: categoryMangas[innerIndex]
                                              .mangaName!,
                                          image:
                                              categoryMangas[innerIndex].image!,
                                          sochap: categoryMangas[innerIndex]
                                              .totalChapters
                                              .toString(),
                                          view: categoryMangas[innerIndex]
                                              .view
                                              .toString(),
                                        );
                                      },
                                    ),
                                  )
                                : category == 'Romance'
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              width: widthS,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3.4,
                                              child: ItemTo(
                                                id: categoryMangas[0].id!,
                                                name: categoryMangas[0]
                                                    .mangaName!,
                                                image: categoryMangas[0].image!,
                                                sochap: categoryMangas[0]
                                                    .totalChapters
                                                    .toString(),
                                              )),
                                          GridView.builder(
                                            padding: EdgeInsets.all(0),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0,
                                              childAspectRatio: 3 / 5,
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: 3,
                                            itemBuilder: (context, innerIndex) {
                                              return ItemTruyenMoi(
                                                  id: categoryMangas[
                                                          innerIndex + 1]
                                                      .id!,
                                                  name: categoryMangas[
                                                          innerIndex + 1]
                                                      .mangaName!,
                                                  image: categoryMangas[
                                                          innerIndex + 1]
                                                      .image!,
                                                  sochap: categoryMangas[
                                                          innerIndex + 1]
                                                      .totalChapters
                                                      .toString(),
                                                  view:
                                                      categoryMangas[innerIndex]
                                                          .view
                                                          .toString());
                                            },
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 220,
                                        child: GridView(
                                          padding: EdgeInsets.all(0),
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: widthS / 1,
                                            childAspectRatio: 4 / 2.3,
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                          ),
                                          children: List.generate(
                                              categoryMangas.length, (index) {
                                            return ItemTruyenMoi(
                                                id: categoryMangas[index].id!,
                                                name: categoryMangas[index]
                                                    .mangaName!,
                                                image: categoryMangas[index]
                                                    .image!,
                                                sochap: categoryMangas[index]
                                                    .totalChapters
                                                    .toString(),
                                                view: categoryMangas[index]
                                                    .view
                                                    .toString());
                                          }),
                                        ),
                                      ))
                  ],
                );
              }).toList(),
            );
          } else {
            return Text('Không có dữ liệu.');
          }
        }
      },
    );
  }
}
