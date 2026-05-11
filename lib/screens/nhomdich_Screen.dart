import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/nhomdich_model.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/screens/detail_mangan.dart';
import 'package:loginapp/user_Service.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// ignore: must_be_immutable
class NhomDichScreen extends StatefulWidget {
  String nhomdichID;
  String userID;
  NhomDichScreen({Key? key, required this.nhomdichID, required this.userID})
      : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<NhomDichScreen> {
  ApiDetaiNhomDich apiDetaiNhomDich = ApiDetaiNhomDich();
  bool nutlike = false;
  Data? currentUser;
  NhomdichModel? nhomdichModel;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

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
    }, onError: (error) {}).then((value) {
      apiDetaiNhomDich
          .fetchData(widget.nhomdichID, widget.userID)
          .then((value) {
        setState(() {
          nhomdichModel = value;
          nutlike = nhomdichModel?.isFollow ?? false;
          isLoading = false;
        });
      });
    });
  }

  void toggleLike() async {
    final apiUrl = nutlike
        ? 'https://be-vantruyen.vercel.app/unfollow/${widget.nhomdichID}/${widget.userID}'
        : 'https://be-vantruyen.vercel.app/follow/${widget.nhomdichID}/${widget.userID}';

    try {
      final response = await dio.post(apiUrl);

      if (response.statusCode == 200) {
        setState(() {
          nutlike = !nutlike;
        });
        CommonService.showToast(
            nutlike
                ? 'Bạn vừa theo dõi nhóm dịch'
                : 'Bạn vừa bỏ theo dõi nhóm dịch',
            context);
      }
    } catch (e) {
      print(' Lỗi khi gửi yêu cầu: $e');
      CommonService.showToast('Đã xảy ra lỗi. Vui lòng thử lại.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorConst.colorPrimary50,
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35),
                            ),
                            child: Image.asset(
                              AssetsPathConst.backgroundStoryDetail,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35),
                            ),
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Positioned(
                            top: 55,
                            left: 15,
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back_ios_new),
                                    Text(
                                      ' Quay lại',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ))),
                        Column(
                          children: [
                            SizedBox(height: 15),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.17),
                                    blurRadius: 10,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: nhomdichModel?.avatar == ''
                                    ? Center(
                                        child: Text(
                                          nhomdichModel?.username
                                                  .substring(0, 1) ??
                                              '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color:
                                                ColorConst.colorBackgroundStory,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: MemoryImage(base64Decode(
                                                nhomdichModel?.avatar ?? '')),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    nhomdichModel?.username ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19),
                                  ),
                                  SizedBox(width: 5),
                                  Image.asset(AssetsPathConst.tichxanh,
                                      height: 20)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${nhomdichModel?.followNumber ?? ''} theo dõi - '
                                        .toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    '${nhomdichModel?.manganumber ?? ''} bài viết'
                                        .toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    toggleLike();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          nutlike ? Colors.white : Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          nutlike
                                              ? AssetsPathConst.icodafollow
                                              : AssetsPathConst.icofollow,
                                          height: 18,
                                        ),
                                        Text(
                                          nutlike ? ' Đã follow' : ' Follow',
                                          style: TextStyle(
                                            color: nutlike
                                                ? ColorConst.colorPrimary50
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _showDonateBottomSheet(
                                        nhomdichModel?.bank[0].hovaten ?? '',
                                        nhomdichModel?.bank[0].phuongthuc ?? '',
                                        nhomdichModel?.bank[0].sotaikhoan ?? '',
                                        nhomdichModel?.bank[0].maQR ?? '');
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: ColorConst.colorPrimary50,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Donate',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Danh sách truyện:'),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final manga = nhomdichModel?.manga[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ZoomTapAnimation(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaDetailScreen(
                                  mangaId: manga?.id ?? '',
                                  storyName: manga?.mangaName ?? '',
                                  image: manga?.image ?? '',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: CachedNetworkImage(
                                      imageUrl: manga?.image ?? '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: 155,
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                        color: ColorConst.colorPrimary50,
                                      )), // Hiển thị khi đang tải ảnh
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )),
                                Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(manga?.mangaName ?? ''),
                                          SizedBox(height: 10),
                                          Text('Tác giả: ${manga?.author}'),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: nhomdichModel?.manga.length ?? 0,
                  ),
                ),
              ],
            ),
    );
  }

  void _showDonateBottomSheet(
      String hovaten, String phuongthuc, String sotaikhoan, String image) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Ủng hộ nhóm dịch qua chuyển khoản:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                hovaten,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.colorPrimary50),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    phuongthuc,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.colorPrimary50),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: phuongthuc))
                          .then((data) {
                        CommonService.showToast('Sao chép thành công', context);
                      });
                    },
                    child: Icon(Icons.copy),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sotaikhoan,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.colorPrimary50),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: sotaikhoan))
                          .then((data) {
                        CommonService.showToast('Sao chép thành công', context);
                      });
                    },
                    child: Icon(Icons.copy),
                  )
                ],
              ),
              SizedBox(height: 10),
              Image.memory(
                base64Decode(image),
                fit: BoxFit.cover,
                height: 150,
                width: 150,
              ),
            ],
          ),
        );
      },
    );
  }
}
