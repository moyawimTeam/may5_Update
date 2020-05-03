import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyawim2/Login_SignUp_Pages/AppIntro.dart';
import 'package:moyawim2/Login_SignUp_Pages/IntroPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  bool loading = true;
  bool seen = false;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    seen = (prefs.getBool('seen') ?? false);
    if (!seen) {
      await prefs.setBool('seen', true);
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return seen ? intro() : AppIntro();
  }
}
