import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = 'doimatkhau';
  final String userId;
  final String username;
  const ChangePasswordScreen(
      {Key? key, required this.userId, required this.username})
      : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newUsernameController = TextEditingController();

  bool _isObscureOldPassword = true;
  bool _isObscureNewPassword = true;
  PasswordChangeService passwordChangeService = PasswordChangeService();
  void _handleChangePassword() async {
    final String userId = widget.userId;
    final String oldPassword = oldPasswordController.text;
    final String newPassword = newPasswordController.text;

    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
      try {
        await passwordChangeService.changePassword(
            userId, oldPassword, newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đổi mật khẩu thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu cũ của bạn không đúng'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleUserName() async {
    final String userId = widget.userId;
    final String newUsername = newUsernameController.text;

    if (newUsername.isNotEmpty) {
      try {
        await passwordChangeService.changeUsername(userId, newUsername);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đổi biệt danh thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xảy ra lỗi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Thay đổi thông tin'),
        backgroundColor: ColorConst.colorPrimary50,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(13.0, 90.0, 13.0, 8.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thay đổi tên'),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorConst.colorPrimary80,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newUsernameController,
                        decoration: InputDecoration(
                          hintText: widget.username,
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 17),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          // Màu chữ khi đang nhập
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 17),
                          errorStyle: TextStyle(color: Colors.black),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        _handleUserName();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 52),
            Text('Thay đổi mật khẩu'),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorConst.colorPrimary80,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: oldPasswordController,
                  obscureText: _isObscureOldPassword,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu cũ',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscureOldPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscureOldPassword = !_isObscureOldPassword;
                        });
                      },
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    // Màu chữ khi đang nhập
                    labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                    errorStyle: TextStyle(color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorConst.colorPrimary80,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: newPasswordController,
                  obscureText: _isObscureNewPassword,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu mới',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscureNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscureNewPassword = !_isObscureNewPassword;
                        });
                      },
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    // Màu chữ khi đang nhập
                    labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                    errorStyle: TextStyle(color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: () {
                _handleChangePassword();
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConst.colorPrimary50),
                child: const Center(
                  child: Text(
                    'Thay đổi mật khẩu',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
