import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/model/category_model.dart';
import 'package:loginapp/screens/detail_mangan.dart';

class MangaListScreen extends StatelessWidget {
  final CategoryModel category;

  MangaListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(category.categoryName ?? 'lỗi'),
          backgroundColor: ColorConst.colorPrimary50,
        ),
        body: ListView.builder(
          itemCount: category.mangaList?.length,
          itemBuilder: (context, index) {
            final manga = category.mangaList![index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MangaDetailScreen(
                        mangaId: manga.id!,
                        storyName: manga.mangaName!,
                        image: manga.image!,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: ColorConst.colorPrimary120),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CachedNetworkImage(
                          imageUrl: manga.image!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      DoubleX.kRadiusSizeGeneric_1XX)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.red.withOpacity(0.10),
                                    BlendMode.colorBurn),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: ColorConst.colorPrimary120,
                          )),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  manga.mangaName!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('Thể loại: ${manga.category}'),
                                Text(
                                    'Chapter ${manga.totalChapters.toString()}'),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
