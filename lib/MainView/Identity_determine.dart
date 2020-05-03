import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Database_Services/Database_services.dart';
import 'package:moyawim2/Loading/loading.dart';
import 'package:moyawim2/MainView/sideBar.dart';
import 'package:provider/provider.dart';

class IdentityDetermine extends StatefulWidget {
  @override
  _IdentityDetermineState createState() => _IdentityDetermineState();
}

class _IdentityDetermineState extends State<IdentityDetermine> {
  bool isEmpr;
  bool loading = true;

  checkEmpr(userId) async {
    isEmpr = await DatabaseOperations(uid: userId).isEmployer();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    checkEmpr(user.uid);
    return loading
        ? Loading()
        : isEmpr
            ? NavDrawer(
                identity: 'Employers',
              )
            : NavDrawer(
                identity: 'Employees',
              );
  }
}
