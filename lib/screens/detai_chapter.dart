import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart';
import 'package:loginapp/Globals.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/detail_chapter.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screens/Driver.dart';
import 'package:loginapp/screens/fetch_more_incaditor.dart';
import 'package:loginapp/user_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen_protector/screen_protector.dart';

class DetailChapter extends StatefulWidget {
  final String chapterId;
  String? storyName;
  final String storyId;
  String? viporfree;
  String? idUser;
  DetailChapter(
      {super.key,
      required this.idUser,
      required this.chapterId,
      this.storyName,
      required this.storyId,
      this.viporfree});

  @override
  State<DetailChapter> createState() => _DetailChapterState();
}

class _DetailChapterState extends State<DetailChapter> {
  ComicChapter? chapterDetail;
  bool _isShowBar = true;
  bool setStatelaidi = true;
  ScrollController _scrollController = ScrollController();

  Data? currentUser;
  _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
          ChapterDetail.fetchChapterImages(
                  widget.chapterId, currentUser?.user[0].id ?? '')
              .then((value) {
            setState(() {
              chapterDetail = value;
            });
          });
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
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    checkfirstRead();

    UserServices us = UserServices();
    print('alo123 ${chapterDetail?.id}');
    us.addChuongVuaDocCuaTruyen(widget.chapterId, widget.viporfree ?? 'free',
        chapterDetail?.name ?? 'lỗi', widget.storyId);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _removeListenerPreventScreenshot();
    _preventScreenshotOff();
  }

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();

    if (isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Screen Recording...'),
      ));
    }
  }

  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();

  void _addListenerPreventScreenshot() async {
    ScreenProtector.addListener(() {
      // Screenshot
      debugPrint('Screenshot:');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Screenshot!'),
      ));
    }, (isCaptured) {
      // Screen Record
      debugPrint('Screen Record:');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Screen Record!'),
      ));
    });
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }

  _checkVipScreenShot() {
    _addListenerPreventScreenshot();
    _preventScreenshotOn();
    _checkScreenRecording();
  }

  Future<void> _goToNewChap(String chapId, String userId) async {
    _scrollToTop();
    print('object $chapId');
    await ChapterDetail.fetchChapterImages(chapId, userId).then((value) {
      setState(() {
        chapterDetail = value;
        widget.viporfree = chapterDetail?.viporfree ?? 'vip';
        UserServices us = UserServices();
        print('alo123 ${chapterDetail?.id}');
        us.addChuongVuaDocCuaTruyen(
            chapterDetail?.id ?? widget.chapterId,
            chapterDetail?.viporfree ?? widget.viporfree!,
            chapterDetail?.name ?? 'lỗi',
            widget.storyId);
        // _scrollController.addListener(_scrollListener);
      });
    });
  }

  Widget _buildBottomBar(ComicChapter? chap) {
    final bool isFirstChapter = chap?.prevChap == null;
    final bool isNextChapter = chap?.nextChap == null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConst.colorPrimary50.withOpacity(0.5)),
            width: 60,
            height: 60,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Icon(
                  Icons.arrow_left,
                  color: isFirstChapter
                      ? ColorConst.colorWhite.withOpacity(0.5)
                      : Colors.black,
                  size: 20,
                ),
                onTap: () {
                  isFirstChapter
                      ? _showToast('Bạn đang đọc chap đầu tiên')
                      : _goToNewChap(chapterDetail?.prevChap?.id ?? '-1',
                          currentUser?.user[0].id ?? '');
                  // go to the previous chapter,
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConst.colorPrimary50.withOpacity(0.5)),
            width: 60,
            height: 60,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Icon(
                  Icons.arrow_right,
                  color: isNextChapter
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black87,
                  size: 20,
                ),
                onTap: () {
                  isNextChapter
                      ? _showToast('Bạn đang đọc chap mới nhất')
                      : _goToNewChap(chapterDetail?.nextChap?.id ?? '-1',
                          currentUser?.user[0].id ?? '');
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildNavbar() {
    return AppBar(
      // toolbarHeight: _isShowBar ? 100 : 0.0,
      title: Text(
        chapterDetail?.name ?? 'Đang tải...',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorConst.colorPrimary50.withOpacity(0.8),
              ColorConst.colorPrimary50.withOpacity(0.7),
              ColorConst.colorPrimary50.withOpacity(0.5),
              Colors.transparent,
              Colors.transparent,
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(setStatelaidi);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            setState(() {
              isFirstTime = true;
            });
          },
        ),
      ],
    );
  }

  void _showToast(String ms) {
    if (ms.contains(StringConst.textyeucaudangnhap)) {
      // update count show user need login: only first show toast need login, after will show snack bar to go to login screen,
      // show snack bar login here,
      CommonService.showSnackBar(StringConst.textyeucaudangnhap, context, () {
        // go to login screen
        RouteUtil.redirectToLoginScreen(context);
      });
      return;
    }

    // SHOW TOAST
    if (!mounted) return;
    CommonService.showToast(ms, context);
  }

  void _scrollToTop() {
    if (_scrollController.hasClients == false) return;
    _scrollController.jumpTo(0);
    // _scrollController.animateTo(
    //   0,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }

  List<String> _extractImageUrlsFromHtml(String htmlString) {
    List<String> imageUrls = [];
    dom.DocumentFragment document = parseFragment(htmlString);
    List<dom.Element> imgElements = document.querySelectorAll('img');
    for (dom.Element imgElement in imgElements) {
      String imageUrl = imgElement.attributes['src'] ?? '...';
      if (imageUrl != null) {
        if (imageUrl.startsWith('http')) imageUrls.add(imageUrl);
        // print(imageUrls);
      }
    }
    return imageUrls;
  }

  List<String> extractImageUrlsFromHtml(String htmlString) {
    List<String> imageUrls = [];
    dom.DocumentFragment document = parseFragment(htmlString);
    List<dom.Element> imgElements = document.querySelectorAll('img');
    for (dom.Element imgElement in imgElements) {
      String imageUrl = imgElement.attributes['src'] ?? '...';
      if (imageUrl != null) {
        imageUrls.add('https:$imageUrl');
      }
    }
    return imageUrls;
  }

  void bychapterlock() async {
    final apiUrl =
        'http://10.0.2.2:8080/purchaseChapter/${currentUser!.user[0].id}/${chapterDetail?.id}';

    try {
      final response = await dio.post(apiUrl);
      if (response.statusCode == 200) {
        setState(() {
          widget.viporfree = 'free';
        });
        _showToast('Bạn vừa mua chap thành công');
      }
    } catch (e) {
      _showToast('Bạn không đủ xu, vui lòng nạp thêm');
    }
  }

  Widget _buildVipChapterBodyPartLock() {
    double height = AppBar().preferredSize.height;
    if (height <= 0) {
      height = DoubleX.kPaddingSizeHuge_1XX;
    }
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            DoubleX.kPaddingSizeLarge,
            height + MediaQuery.of(context).padding.top,
            DoubleX.kPaddingSizeLarge,
            DoubleX.kPaddingSizeZero),
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          cacheExtent: 0,
          padding: EdgeInsets.only(bottom: 30),
          shrinkWrap: true,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  StringConst.textThongBao,
                  style: TextStyle(
                    fontSize: DoubleX.kFontSizeTiny_1XXX,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: DoubleX.kPaddingSizeMedium_1XXX,
                  ),
                ),
                const Text(
                  StringConst.textThongBaoChapVip,
                  style: TextStyle(fontSize: DoubleX.kFontSizeTiny_1X1X),
                ),
                Padding(
                  padding: EdgeInsets.only(top: DoubleX.kPaddingSizeLarge_1XX),
                  child: Wrap(
                    children: [
                      Text(
                        StringConst.suggestUsersDoMission,
                        style: TextStyle(
                            fontSize: DoubleX.kFontSizeTiny_1X1X,
                            fontWeight: FontWeight.bold,
                            color: ColorConst.colorDanger),
                      )
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: DoubleX.kPaddingSizeLarge,
                ),
                GestureDetector(
                  onTap: () async {
                    bychapterlock();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock,
                            color: ColorConst.colorPrimaryText,
                          ),
                          const SizedBox(
                            width: DoubleX.kPaddingSizeTiny,
                          ),
                          Text("Mở Khóa )",
                              style: const TextStyle(
                                color: ColorConst.colorPrimaryText,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: DoubleX.kPaddingSizeLarge,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyChapter(String sChapContent) {
    print('${widget.viporfree}');

    // chap is vip
    if (widget.viporfree == 'vip') {
      _isShowBar = true;
      return Stack(
        children: [_buildVipChapterBodyPartLock()],
      );
    } else {
      return _buildChapterBodyPartNormal(sChapContent);
    }
  }

  Widget _buildChapterBodyPartNormal(String sChapContent) {
    List<String> imageUrls = _extractImageUrlsFromHtml(sChapContent);
    _checkVipScreenShot();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: imageUrls.isNotEmpty
          ? InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                setState(() {});
              },
              child: ListView(
                shrinkWrap: true,
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 0, top: 0),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      imageUrls.length,
                      (index) => Stack(
                        children: [
                          // CachedNetworkImage as the background
                          CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width,
                            imageUrl: imageUrls[index],
                            placeholder: (context, url) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: index < 5
                                        ? 120
                                        : MediaQuery.of(context).size.height /
                                            4,
                                  ),
                                  child: Image.asset(
                                    AssetsPathConst.gifloading,
                                    width: 50,
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          // Watermark as an overlay
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'MangaLand',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Globals.isAutoNoiChap == false
                      ? Container()
                      : Transform.translate(
                          offset: const Offset(0.0, 0),
                          child: Visibility(
                            visible: true,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 35,
                                ),
                                Icon(
                                  Icons.arrow_upward_sharp,
                                  size: 25,
                                ),
                                Text(
                                  'Kéo lên để chuyển chap mới',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            )
          : Center(
              child: Image.asset(
                AssetsPathConst.gifloading,
                width: 50,
              ),
            ),
    );
  }

  bool isFirstTime = true;
  Future<void> checkfirstRead() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool('checkfirstRead') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          setState(() {
            _isShowBar = !_isShowBar;
          });
        },
        child: Stack(
          children: [
            FetchMoreIndicator(
              onAction: () {
                Globals.isAutoNoiChap == false
                    ? null
                    : _goToNewChap(chapterDetail?.nextChap?.id ?? '-1',
                        currentUser?.user[0].id ?? '');
              },
              color: ColorConst.colorBackgroundStory,
              child: ListView.builder(
                // controller: _scrollController,
                // physics: AlwaysScrollableScrollPhysics(),
                // scrollDirection: Axis.vertical,
                itemCount: chapterDetail?.images.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // print('${chapterDetail?.images[index]}');
                  return _buildBodyChapter(chapterDetail?.images[index] ?? '');
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                height: _isShowBar
                    ? 76.0 + MediaQuery.of(context).viewPadding.top
                    : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _buildNavbar(),
              ),
            ),
            Globals.isRight == false
                ? Positioned(
                    left: 5,
                    bottom: 275,
                    top: 270,
                    child: AnimatedContainer(
                      width: _isShowBar ? 56.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: _buildBottomBar(chapterDetail),
                    ),
                  )
                : Positioned(
                    // left: 0,
                    right: 5,
                    bottom: 275,
                    top: 270,
                    child: AnimatedContainer(
                      width: _isShowBar ? 56.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: _buildBottomBar(chapterDetail),
                    ),
                  ),
            !isFirstTime
                ? Container()
                : Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.8),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 7,
                                child: DottedVerticalDivider(),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 7,
                                child: DottedVerticalDivider(),
                              )
                            ],
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 60),
                                Column(
                                  children: [
                                    const SizedBox(height: 35),
                                    Transform.rotate(
                                      angle: 6,
                                      child: Image.asset(
                                        AssetsPathConst.ico_1,
                                        height: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Chạm 2 lần vào màn hình \n để ẩn/hiện thanh tab',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 35),
                                Column(
                                  children: [
                                    Text(
                                      'Cuộn xuống dưới cùng để\ntự động chuyển chap \n (khi bật nối chap tự động ở tài khoản)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 70,
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    side: MaterialStateProperty.all<BorderSide>(
                                      const BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('checkfirstRead', false);
                                    setState(() {
                                      isFirstTime = false;
                                    });
                                  },
                                  child: const Text(
                                    'Đã hiểu',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  ScrollDirection? _previousScrollDirection;
  void clearCacheMemory() {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    _imageCache.clearLiveImages();
  }

  void _scrollListener() {
    final currentScrollDirection =
        _scrollController.position.userScrollDirection;

    if (_previousScrollDirection != currentScrollDirection) {
      setState(() {
        _previousScrollDirection = currentScrollDirection;
        if (currentScrollDirection == ScrollDirection.forward) {
          _isShowBar = true;
          print('cuộn lên nè');
        } else if (currentScrollDirection == ScrollDirection.reverse) {
          _isShowBar = false;
          print('cuộn xuống nè');
        }
      });
    }
  }
}
