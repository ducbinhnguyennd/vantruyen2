import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/main_screen.dart';
import 'package:loginapp/screens/introsignin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String routeName = '/splash_screen';

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    startSplashTimer();
    // checkFirstRead();
    // checkLoginStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username != null) {
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(IntroSigin.routeName);
    }
  }

  Future<void> checkFirstRead() async {
    await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool('checkfirstRead') ?? true;
    });
    nextScreen();
  }

  void nextScreen() async {
    if (isFirstTime) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('checkfirstRead', false);
      Navigator.of(context).pushReplacementNamed(IntroSigin.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    }
  }

  void startSplashTimer() {
    Timer(Duration(seconds: 2), () {
      checkFirstRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: ColorConst.colorWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetsPathConst.splashBackgroundNgonTinh,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
