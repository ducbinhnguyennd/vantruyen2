import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/nhomdichtheodoi_model.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/screens/detail_mangan.dart';
import 'package:loginapp/screens/nhomdich_Screen.dart';
import 'package:loginapp/user_Service.dart';

import '../model/trangchu_model.dart';

class FavoriteMangaScreen extends StatefulWidget {
  @override
  _FavoriteMangaScreenState createState() => _FavoriteMangaScreenState();
}

class _FavoriteMangaScreenState extends State<FavoriteMangaScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<Manga> favoriteManga = [];
  List<DichTheoDoiModel> dichTheoDoiModel = [];
  Data? currentUser;
  late TabController _tabController;
  // ApiDichTheoDoi apiDichTheoDoi = ApiDichTheoDoi();
  Future<void> _refresh() async {
    await _loadUser();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _loadUser() async {
    UserServices us = UserServices();
    us
        .getInfoLogin()
        .then((value) {
          if (value != "") {
            setState(() {
              currentUser = Data.fromJson(jsonDecode(value));
            });
          } else {
            setState(() {
              currentUser = null;
            });
          }
        }, onError: (error) {})
        .then((value) async {
          print('userid: ${currentUser?.user[0].id}');
          List<Manga> mangaList = await ApiListYeuThich.fetchFavoriteManga(
            currentUser?.user[0].id ?? '',
          );
          List<DichTheoDoiModel> dichTheoDoiList =
              await ApiDichTheoDoi.fetchData(currentUser?.user[0].id ?? '');
          setState(() {
            favoriteManga = mangaList;
            dichTheoDoiModel = dichTheoDoiList;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(favoriteManga.length);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Tủ Truyện'),
        backgroundColor: ColorConst.colorPrimary50,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: [Tab(text: 'Truyện đã lưu'), Tab(text: 'Nhóm dịch yêu thích')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            color: ColorConst.colorPrimary120,
            onRefresh: _refresh,
            child:
                favoriteManga.isEmpty
                    ? ListView(
                      padding: EdgeInsets.all(50),
                      children: [
                        Container(
                          child: Center(
                            child: Text('Bạn chưa có truyện nào yêu thích'),
                          ),
                        ),
                      ],
                    )
                    : ListView.builder(
                      itemCount: favoriteManga.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MangaDetailScreen(
                                        mangaId: favoriteManga[index].id!,
                                        storyName:
                                            favoriteManga[index].mangaName!,
                                        image: favoriteManga[index].image!,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: ColorConst.colorPrimary120,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CachedNetworkImage(
                                      imageUrl: favoriteManga[index].image!,
                                      imageBuilder:
                                          (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(
                                                      DoubleX
                                                          .kRadiusSizeGeneric_1XX,
                                                    ),
                                                  ),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.red.withOpacity(0.10),
                                                  BlendMode.colorBurn,
                                                ),
                                              ),
                                            ),
                                          ),
                                      placeholder:
                                          (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              color: ColorConst.colorPrimary120,
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => const Center(
                                            child: Icon(Icons.error),
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            favoriteManga[index].mangaName!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Thể loại: ${favoriteManga[index].category}',
                                          ),
                                          Text(
                                            'Chapter ${favoriteManga[index].totalChapters.toString()}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          RefreshIndicator(
            color: ColorConst.colorPrimary120,
            onRefresh: _refresh,
            child:
                dichTheoDoiModel.isEmpty
                    ? ListView(
                      padding: EdgeInsets.all(50),
                      children: [
                        Container(
                          child: Center(
                            child: Text('Bạn chưa yêu thích nhóm dịch nào'),
                          ),
                        ),
                      ],
                    )
                    : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 0.0,
                        childAspectRatio: 3 / 5,
                      ),
                      itemCount: dichTheoDoiModel.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => NhomDichScreen(
                                        nhomdichID: dichTheoDoiModel[index].id,
                                        userID: currentUser?.user[0].id ?? '',
                                      ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorConst.colorPrimary,
                                  ),
                                  child:
                                      dichTheoDoiModel[index].avatar == ''
                                          ? Center(
                                            child: Text(
                                              dichTheoDoiModel[index].username
                                                  .substring(0, 1),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                          : ClipOval(
                                            child: Image.memory(
                                              base64Decode(
                                                dichTheoDoiModel[index].avatar,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dichTheoDoiModel[index].username,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Image.asset(
                                      AssetsPathConst.tichxanh,
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
