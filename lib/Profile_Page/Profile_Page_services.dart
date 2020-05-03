import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Database_Services/Database_services.dart';
import 'package:moyawim2/Loading/BlueLoading.dart';
import 'package:moyawim2/Profile_Page/Employee_Profile.dart';
import 'package:moyawim2/Profile_Page/Employer_Profile.dart';
import 'package:moyawim2/Profile_Page/SizeConfig.dart';
import 'package:provider/provider.dart';

class ProfilePageEnum extends StatefulWidget {
  @override
  _ProfilePageEnumState createState() => _ProfilePageEnumState();
}

class _ProfilePageEnumState extends State<ProfilePageEnum> {
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
        ? BlueLoading()
        : !isEmpr
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      SizeConfig().init(constraints, orientation);
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'HomeScreen App',
                        home: EmployeeProfile(
                          userId: user.uid,
                          isMe: true,
                        ),
                      );
                    },
                  );
                },
              )
            : EmployerProfile(
                userId: user.uid,
                isMe: true,
              );
  }
}
