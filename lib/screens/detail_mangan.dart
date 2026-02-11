import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/login_screen.dart';
import 'package:loginapp/model/detailtrangchu_model.dart';
import 'package:loginapp/screens/detai_chapter.dart';
import 'package:loginapp/screens/nhomdich_Screen.dart';
import 'package:loginapp/user_Service.dart';
import 'package:share_plus/share_plus.dart';
import '../model/user_model.dart';

class MangaDetailScreen extends StatefulWidget {
  final String mangaId;
  final String storyName;
  final String image;
  const MangaDetailScreen(
      {super.key,
      required this.mangaId,
      required this.storyName,
      required this.image});

  @override
  _MangaDetailScreenState createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen>
    with TickerProviderStateMixin {
  MangaDetailModel? mangaDetail;
  String? chapterDocTiepId;
  String? chapterDocTuDau;
  late TabController _controller;
  bool nutlike = false;
  int _currentTabIndex = 0;
  String chapterTitleDocTiep = "Đọc tiếp";
  Data? currentUser;
  bool _isLoading = true;
  String viporfree = "free";
  _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {
      if (kDebugMode) {
        print(
            '_alexTR_logging_ : SettingPage: _loadUser: error: ${error.toString()}');
      }
    }).then((value) {
      MangaDetail.fetchMangaDetail(
              widget.mangaId, currentUser?.user[0].id ?? '')
          .then((value) {
        print('value day $value');
        setState(() {
          mangaDetail = value;
          nutlike = mangaDetail?.isLiked ?? false;
        });
      });
      print('in data ra day $mangaDetail');
    });
  }

  Future<void> _refresh() async {
    await _loadUser();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUser();

    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentTabIndex = _controller.index;
    });
  }

  buildContent(String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giới thiệu:'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  buildDocTiep(MangaDetailModel? detail, String viporfree1) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailChapter(
                    idUser: currentUser!.user[0].id,
                    chapterId: detail?.chapters[0].idchap ?? '',
                    storyName: detail?.chapters[0].namechap,
                    storyId: widget.mangaId,
                    viporfree: detail?.chapters[0].viporfree,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 0.5),
              color: ColorConst.colorPrimary50,
              height: 70,
              child: const Center(
                child: Text(
                  'Đọc từ đầu',
                  maxLines: 1,
                  style: TextStyle(
                    color: ColorConst.colorPrimaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: DoubleX.kFontSizeTiny_1XX,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: (chapterDocTiepId == null || chapterDocTiepId!.length <= 2)
                ? () {
                    CommonService.showToast(
                        'Bạn chưa đọc chap đầu tiên', context);
                  }
                : () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailChapter(
                            idUser: currentUser!.user[0].id,
                            chapterId: chapterDocTiepId ??
                                detail?.chapters[0].idchap ??
                                '',
                            storyName: chapterTitleDocTiep,
                            storyId: widget.mangaId,
                            viporfree: viporfree1,
                          ),
                        ),
                      ).then((value) {
                        setState(() {
                          _loadData();
                          _loadUser();
                        });
                      });
                      ;
                    }
                  },
            child: Container(
              margin: EdgeInsets.only(left: 1),
              color: chapterDocTiepId == null
                  ? ColorConst.colorPrimary.withOpacity(0.6)
                  : ColorConst.colorPrimary50,
              height: 70,
              child: const Center(
                child: Text(
                  'Đọc tiếp',
                  maxLines: 1,
                  style: TextStyle(
                    color: ColorConst.colorPrimaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: DoubleX.kFontSizeTiny_1XX,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildThongSo(String follow, String view, String chap, String binhluan) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                follow,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: DoubleX.kFontSizeTiny_1XXX),
              ),
              const Text(
                'Theo dõi',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Column(
            children: [
              Text(
                view,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: DoubleX.kFontSizeTiny_1XXX),
              ),
              const Text(
                'Lượt xem',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Column(
            children: [
              Text(
                chap,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: DoubleX.kFontSizeTiny_1XXX),
              ),
              const Text(
                'Chapters',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Column(
            children: [
              Text(
                binhluan,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: DoubleX.kFontSizeTiny_1XXX),
              ),
              const Text(
                'Bình luận',
                style: TextStyle(color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Text('Đăng nhập đi các cu em'),
          ),
        ),
      );
    } else if (mangaDetail == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.colorPrimary50,
          title: Text('Đang tải...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: ColorConst.colorPrimary,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.colorPrimary50,
          title: Text(widget.storyName),
          bottom: TabBar(
              controller: _controller,
              indicatorColor: Colors.white,
              tabs: _buildTabBarTitlesList()),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            buildGioiThieu(viporfree),
            buildChapter(),
            buildComments()
          ],
        ),
      );
    }
  }

  Widget buildChapter() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: mangaDetail?.chapters.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailChapter(
                  idUser: currentUser!.user[0].id,
                  chapterId: mangaDetail?.chapters[index].idchap ?? '',
                  storyName: mangaDetail?.chapters[index].namechap,
                  storyId: widget.mangaId,
                  viporfree: mangaDetail!.chapters[index].viporfree,
                ),
              ),
            ).then((value) {
              setState(() {
                _loadData();
                _loadUser();
              });
            });
          },
          child: ListTile(
            title: Text('Chapter ${mangaDetail?.chapters[index].namechap}'),
            subtitle: Text('Loại: ${mangaDetail?.chapters[index].viporfree}'),
            trailing: _buildChapterIcon(mangaDetail!.chapters[index].viporfree),
          ),
        );
      },
    );
  }

  Widget _buildChapterIcon(String vipOrFree) {
    if (vipOrFree.toLowerCase() == 'vip') {
      return Icon(Icons.lock, color: ColorConst.colorPrimary50);
    } else {
      return Icon(Icons.lock_open, color: Colors.green);
    }
  }

  final TextEditingController commentController = TextEditingController();
  Widget buildComments() {
    return RefreshIndicator(
      color: ColorConst.colorPrimary120,
      onRefresh: _refresh,
      child: Column(
        children: [
          Expanded(
            child: mangaDetail!.cmts.isEmpty
                ? Center(
                    child: Text('Chưa có bình luận'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: mangaDetail?.cmts.length,
                    itemBuilder: (context, index) {
                      bool isCurrentUserComment = currentUser?.user[0].id ==
                          mangaDetail?.cmts[index].userIdcmt;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(15),
                          //     color: ColorConst.colorPrimary80),
                          child: Row(
                            children: [
                              mangaDetail?.cmts[index].avatar == ''
                                  ? SizedBox(
                                      width: DoubleX.kSizeLarge_1X,
                                      height: DoubleX.kSizeLarge_1X,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            ColorConst.colorPrimary80,
                                        child: Text(
                                          mangaDetail?.cmts[index].usernamecmt
                                                  .toString()
                                                  .substring(0, 1) ??
                                              '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: MemoryImage(base64Decode(
                                              mangaDetail?.cmts[index].avatar ??
                                                  '')),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            mangaDetail
                                                    ?.cmts[index].usernamecmt ??
                                                '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        SizedBox(width: 5),
                                        if (mangaDetail?.cmts[index].rolevip ==
                                            'vip')
                                          Image.asset(
                                            AssetsPathConst.tichxanh,
                                            height: 18,
                                          )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Text(
                                          mangaDetail?.cmts[index].noidung ??
                                              ''),
                                    ),
                                    Text(
                                      mangaDetail?.cmts[index].date ?? '',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              isCurrentUserComment
                                  ? IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        deleteComment(
                                            mangaDetail?.cmts[index].idcmt,
                                            widget.mangaId,
                                            mangaDetail?.cmts[index].userIdcmt);
                                        await Future.delayed(
                                            Duration(seconds: 2));

                                        _loadUser();
                                        Fluttertoast.showToast(
                                          msg: "Xóa bình luận thành công",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      },
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: ColorConst.colorPrimary120),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          labelText: 'Nhập bình luận',
                          focusColor: Colors.black,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        String comment = commentController.text;
                        if (comment.isNotEmpty && comment.length >= 5) {
                          CommentService.postComment(
                              currentUser?.user[0].id ?? '',
                              widget.mangaId,
                              comment);
                          commentController.clear();
                          _loadUser();
                          Fluttertoast.showToast(
                            msg: "Bình luận đang được tải lên...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                          await Future.delayed(Duration(seconds: 2));

                          Fluttertoast.showToast(
                            msg: "Đăng bình luận thành công",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Nhập ít nhất 5 kí tự",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      },
                      child: const Icon(
                        Icons.send_rounded,
                        color: ColorConst.colorPrimary50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteComment(String? commentId, String? mangaId, String? userId) {
    XoaComment.xoaComment(commentId!, mangaId!, userId!);
  }

  _loadData() {
    UserServices us = UserServices();
    us.readChuongVuaDocOfTruyen(widget.mangaId).then((data) async {
      String? sData = await data;
      if (sData != null && sData.isNotEmpty) {
        dynamic data2 = jsonDecode(sData);
        if (mounted) {
          setState(() {
            chapterDocTiepId = data2['idchap'];
            chapterTitleDocTiep = data2['titlechap'] + " \u279C";
            viporfree = data2['viporfree'];
            print('o day la gi $viporfree');
          });
        }
      } else {
        if (mounted) {
          // setState(() {
          //   chapterDocTiepId = MangaDetailModel.;
          // });
        }
      }
    });
  }

  Widget buildGioiThieu(String vip1) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.image,
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: CachedNetworkImage(
                            imageUrl: widget.image,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 180,
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Truyện: ${mangaDetail?.mangaName}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          color: Colors.black,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Tác giả: ${mangaDetail?.author}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          color: Colors.white,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    )),
                                Text('Thể loại: ${mangaDetail?.category}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          color: Colors.white,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              buildThongSo(
                  mangaDetail!.like.toString(),
                  mangaDetail!.view.toString(),
                  mangaDetail!.totalChapters.toString(),
                  mangaDetail!.totalcomment.toString()),
              const SizedBox(height: 15),
              const Divider(
                color: Colors.grey,
                height: 0.2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nhóm dịch:'),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NhomDichScreen(
                              nhomdichID: mangaDetail!.nhomdichId,
                              userID: currentUser!.user[0].id,
                              // idUser: currentUser!.user[0].id,
                              // chapterId: detail?.chapters[0].idchap ?? '',
                              // storyName: detail?.chapters[0].namechap,
                              // storyId: widget.mangaId,
                              // viporfree: detail?.chapters[0].viporfree,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConst.colorPrimary50),
                            child: Center(
                              child: Text(
                                mangaDetail!.nhomdich.substring(0, 1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: ColorConst.colorBackgroundStory,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            mangaDetail!.nhomdich,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Text(
                            '  xem thêm',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              buildContent(mangaDetail!.content),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 5,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    toggleLike();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConst.colorPrimary50),
                    child: Icon(
                      nutlike ? Icons.favorite : Icons.favorite_border,
                      size: 35,
                      color: nutlike ? Colors.white : Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    try {
                      final box = context.findRenderObject() as RenderBox?;
                      await Share.share(
                        'Đọc ${mangaDetail!.mangaName} ngay tại: ${mangaDetail!.linktruyen}',
                        subject: '${mangaDetail!.mangaName}',
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size,
                      ).then((value) {});
                    } on Exception catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConst.colorPrimary50),
                    child: Icon(
                      Icons.share,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: buildDocTiep(mangaDetail!, vip1),
    );
  }

  final dio = Dio();

  void toggleLike() async {
    final apiUrl = nutlike
        ? 'https://be-vantruyen.vercel.app/user/removeFavoriteManga/${currentUser!.user[0].id}/${widget.mangaId}'
        : 'https://be-vantruyen.vercel.app/user/addFavoriteManga/${currentUser!.user[0].id}/${widget.mangaId}';

    try {
      final response = await dio.post(apiUrl);

      if (response.statusCode == 200) {
        setState(() {
          nutlike = !nutlike;
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Thành công'),
              content: Text(
                  'Truyện đã được ${nutlike ? 'Thêm yêu thích' : 'Bỏ yêu thích'}.'),
            );
          },
        );
      }
    } catch (e) {
      // Xử lý lỗi nếu có
    }
  }

  _buildTabBarTitlesList() {
    return [
      Tab(
        child: Container(
          child: const Text(
            'Giới thiệu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DoubleX.kFontSizeTiny_1XX,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ),
      const Tab(
        child: Text(
          'Chapter',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: DoubleX.kFontSizeTiny_1XX,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      const Tab(
        child: Text(
          'Bình luận',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: DoubleX.kFontSizeTiny_1XX,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    ];
  }
}
