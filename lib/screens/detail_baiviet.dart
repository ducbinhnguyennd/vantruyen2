import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/bangtin_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screens/report_screen.dart';

class DetailBaiViet extends StatefulWidget {
  const DetailBaiViet(
      {super.key, required this.baivietID, required this.userID});
  final String baivietID;
  final String userID;
  @override
  State<DetailBaiViet> createState() => _DetailBaiVietState();
}

class _DetailBaiVietState extends State<DetailBaiViet> {
  ApiDetailBaiViet apiDetailBaiViet = ApiDetailBaiViet();
  TextEditingController _commentController = TextEditingController();
  ApiSCommentBaiDang _apiService = ApiSCommentBaiDang();
  LikeApiService likeApiService = LikeApiService();

  // void toggleLike() {
  bool isMyComment(String commentUserId) {
    return commentUserId == widget.userID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
        title: Text('Bài viết chi tiết'),
        leading: InkWell(
            onTap: (() {
              Navigator.pop(context, false);
            }),
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: apiDetailBaiViet.fetchDetailBaiviet(
                    widget.baivietID, widget.userID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: ColorConst.colorPrimary120,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Bài viết này không tồn tại"));
                  } else {
                    Bangtin bangtin = snapshot.data as Bangtin;
                    return ListView(
                      padding: EdgeInsets.all(10),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                                  child: bangtin.avatar == ""
                                      ? CircleAvatar(
                                          backgroundColor:
                                              ColorConst.colorPrimary,
                                          child: Text(
                                            bangtin.username.substring(0, 1),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Container(
                                          height: 44,
                                          width: 44,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: MemoryImage(base64Decode(
                                                  bangtin.avatar ?? '')),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          bangtin.username,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5),
                                        if (bangtin.rolevip == 'vip')
                                          Image.asset(AssetsPathConst.tichxanh,
                                              height: 18)
                                      ],
                                    ),
                                    Text(
                                      bangtin.date ??
                                          '2023-11-18T04:38:10.828Z',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Spacer(),

                                // widgetDelete ?? Container()
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 5, 15.0, 15.0),
                              child: Text(
                                bangtin.content ?? '',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            if (bangtin.images != null)
                              for (String imageBase64 in bangtin.images ?? [])
                                Image.memory(
                                  base64Decode(imageBase64),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${bangtin.like} lượt thích'),
                                Text('${bangtin.cmt} bình luận')
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // ignore: unnecessary_null_comparison
                                          if (bangtin.userId != null) {
                                            if (!bangtin.isLiked) {
                                              // If the post is not liked, allow the user to like it
                                              setState(() {
                                                bangtin.isLiked = true;
                                              });
                                              likeApiService.likeBaiViet(
                                                  bangtin.userId,
                                                  widget.baivietID);
                                            } else {
                                              // If the post is already liked, show a toast message
                                              _showToast(
                                                  "Bạn đã thích bài viết này");
                                            }
                                          } else {
                                            _showToast(
                                                StringConst.textyeucaudangnhap);
                                          }
                                        },
                                        child: Icon(
                                          bangtin.isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: bangtin.isLiked
                                              ? ColorConst.colorPrimary50
                                              : Colors.grey[350],
                                          size: 25,
                                        ),
                                      ),
                                      Text(' Tim')
                                    ],
                                  ),
                                  // widgetPostCM ?? Container(),

                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReportScreen(
                                            baivietID: widget.baivietID,
                                            userID: widget.userID,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.report,
                                            size: 25, color: Colors.grey[350]),
                                        Text(' Report')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: ColorConst.colorPrimary80,
                              thickness: 5,
                            ),
                            if (bangtin.comments != null)
                              for (Comment comment in bangtin.comments!)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        isMyComment(comment.userId ?? '')
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: [
                                      if (comment.userId == widget.userID)
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            XoaCommentBaiDang.xoaComment(
                                              comment.id ?? '',
                                              widget.baivietID,
                                              widget.userID,
                                            ).then((_) {
                                              setState(() {});
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Xóa bình luận thành công'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            setState(() {});
                                          },
                                        ),
                                      if (!isMyComment(comment.userId ?? ''))
                                        comment.avatar == ''
                                            ? SizedBox(
                                                width: DoubleX.kSizeLarge_1X,
                                                height: DoubleX.kSizeLarge_1X,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      ColorConst.colorPrimary,
                                                  child: Text(
                                                    comment.username
                                                        .toString()
                                                        .substring(0, 1),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: DoubleX.kSizeLarge_1X,
                                                height: DoubleX.kSizeLarge_1X,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: MemoryImage(
                                                        base64Decode(
                                                            comment.avatar ??
                                                                '')),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              isMyComment(comment.userId ?? '')
                                                  ? EdgeInsets.only(right: 8.0)
                                                  : EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: isMyComment(
                                                      comment.userId ?? '')
                                                  ? ColorConst.colorPrimary80
                                                  : Colors.grey[300],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: isMyComment(
                                                      comment.userId ?? '')
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      comment.username ?? '',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(width: 5),
                                                    if (comment.rolevip ==
                                                        'vip')
                                                      Image.asset(
                                                          AssetsPathConst
                                                              .tichxanh,
                                                          height: 18)
                                                  ],
                                                ),
                                                Text(comment.content ?? ''),
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    Text(comment.date ?? 'aloo',
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (isMyComment(comment.userId ?? ''))
                                        comment.avatar == ''
                                            ? SizedBox(
                                                width: DoubleX.kSizeLarge_1X,
                                                height: DoubleX.kSizeLarge_1X,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      ColorConst.colorPrimary,
                                                  child: Text(
                                                    comment.username
                                                        .toString()
                                                        .substring(0, 1),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: DoubleX.kSizeLarge_1X,
                                                height: DoubleX.kSizeLarge_1X,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: MemoryImage(
                                                        base64Decode(
                                                            comment.avatar ??
                                                                '')),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                    ],
                                  ),
                                )
                          ],
                        )
                      ],
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: ColorConst.colorPrimary120,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Nhập bình luận...',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _postComment();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _postComment() {
    String baivietId = widget.baivietID;
    String userId = widget.userID;
    String comment = _commentController.text.trim();

    if (comment.isNotEmpty && comment.length >= 5) {
      _apiService.postComment(baivietId, userId, comment).then((_) {
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng bình luận thành công'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bình luận quá ngắn, vui lòng nhập ít nhất 5 ký tự.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showToast(String msg) {
    if (msg.contains(StringConst.textyeucaudangnhap)) {
      CommonService.showSnackBar(StringConst.textyeucaudangnhap, context, () {
        RouteUtil.redirectToLoginScreen(context);
      });
      return;
    }

    CommonService.showToast(msg, context);
  }
}
