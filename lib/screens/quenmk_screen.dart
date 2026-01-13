import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/getapi/trangchuapi.dart';

class QuenMatKhauScreen extends StatefulWidget {
  QuenMatKhauScreen({super.key});

  static const routeName = 'login_screen';

  @override
  State<QuenMatKhauScreen> createState() => _QuenMatKhauScreenState();
}

class _QuenMatKhauScreenState extends State<QuenMatKhauScreen> {
  String _username = '';
  String tt = '';
  String _phone = '';

  String _password = '';
  TextEditingController userEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();

  TextEditingController passwEditingController = TextEditingController();
  QuenMatKhau quenMatKhau = QuenMatKhau();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, ColorConst.colorPrimary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 30,
                      blurRadius: 40,
                      offset: Offset(0, -25),
                    ),
                  ]),
            ),
          ),
          ListView(
            padding: EdgeInsets.only(top: 150),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chào mừng bạn đến với',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                  Text('MangaLand',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: textField(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                            var response = await quenMatKhau.forgetpass(
                                _username, _phone, _password);

                            if (response?.statusCode == 200) {
                              CommonService.showToast(
                                  'Lấy lại mật khẩu thành công', context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Sai tên đăng nhập hoặc số điện thoại"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: ColorConst.colorPrimary50),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Gửi',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                            ),
                          )),
                      SizedBox(
                        width: 40,
                      ),
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: ColorConst.colorPrimary50),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      )),
    );
  }

  Widget buildTextField({
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextEditingController? controller,
    Function(String)? onChanged,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: isPassword,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      showCursor: true,
      cursorColor: Color.fromARGB(255, 0, 0, 0),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontWeight: FontWeight.w300),
        prefixIcon: Icon(
          prefixIcon,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
            borderRadius: BorderRadius.circular(10)),
        floatingLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 18,
            fontWeight: FontWeight.w300),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget buildTextFieldPhone({
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLength: 10,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      showCursor: true,
      cursorColor: Color.fromARGB(255, 0, 0, 0),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontWeight: FontWeight.w300),
        prefixIcon: Icon(
          prefixIcon,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
            borderRadius: BorderRadius.circular(10)),
        floatingLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 18,
            fontWeight: FontWeight.w300),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Column textField() {
    return Column(
      children: [
        buildTextField(
          labelText: 'Tên đăng nhập',
          hintText: 'Tên đăng nhập',
          prefixIcon: Icons.people,
          controller: userEditingController,
          onChanged: (val) {
            setState(() {
              //isPhoneCorrect = isEmail(val);
              _username = val;
            });
          },
        ),
        SizedBox(
          height: 24,
        ),
        buildTextFieldPhone(
          labelText: 'Số điện thoại',
          hintText: '0*********',
          prefixIcon: Icons.phone,
          controller: phoneEditingController,
          onChanged: (val) {
            setState(() {
              //isPhoneCorrect = isEmail(val);
              _phone = val;
            });
          },
        ),
        SizedBox(
          height: 24,
        ),
        buildTextField(
            labelText: 'Mật khẩu',
            hintText: '******',
            prefixIcon: Icons.password_outlined,
            controller: passwEditingController,
            onChanged: (val) {
              setState(() {
                //isPhoneCorrect = isEmail(val);
                _password = val;
              });
            },
            isPassword: true),
      ],
    );
  }
}
