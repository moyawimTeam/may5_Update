import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:moyawim2/Login_SignUp_Pages/IntroPage.dart';

void main() => runApp(AppIntro());

class AppIntro extends StatelessWidget {
  static final String moyawimText =
      "يتيح لك تطبيق مياوم امكانية وضع فرص العمل والتواصل مع ارباب العمل";
  static final String managerTitle = "رب العمل";
  static final String managerText =
      "يمكنك كرب عمل التعرف على فرص العمل المطروحة من قبل المياومين وإمكانية التواصل معهم";
  final pages = [
    PageViewModel(
      pageColor: Colors.blue.shade300,
      title: Text(
        "!مرحباً بك",
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      mainImage: Container(
        height: 150,
        width: 270,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/Logo-Moyawem.jpeg",
                ))),
      ),
      body: Text("أهلا بك في تطبيق مياوم اسحب لليسار للبدأ"),
    ),
    PageViewModel(
      pageColor: Colors.grey,
      title: Text(
        "مياوم",
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      mainImage: Container(
        height: 150,
        width: 250,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 3),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/Moyawim.jpg",
                ))),
      ),
      body: Text(
        moyawimText,
        style: TextStyle(fontSize: 20),
      ),
    ),
    PageViewModel(
      pageColor: Colors.lightGreen,
      title: Text(
        managerTitle,
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      mainImage: Container(
        height: 120,
        width: 260,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 3),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/manager.jpg",
                ))),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            managerText,
            style: TextStyle(fontSize: 20),
          )),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => IntroViewsFlutter(
            pages,
            doneText: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(_createRoute());
              },
              child: Text(
                "تم",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            skipText: Text(
              "تخطي",
              style: TextStyle(color: Colors.white),
            ),
//            fullTransition: 100,
          ),
        ));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => intro(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
