import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Login_SignUp_Pages/firstTimeChecker.dart';
import 'package:moyawim2/MainView/sideBar.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Splash();
    } else {
      return SideBar();
    }
  }
}
