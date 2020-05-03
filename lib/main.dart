import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/authservice.dart';
import 'package:moyawim2/Wrapper/wrapper.dart';
import 'package:provider/provider.dart';

import 'Authentication_services/User.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
//          home: Wrapper(),
        ),
      ),
    );
  }
}
