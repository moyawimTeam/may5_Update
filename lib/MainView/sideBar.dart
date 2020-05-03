import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Authentication_services/authservice.dart';
import 'package:moyawim2/Database_Services/Database_services.dart';
import 'package:moyawim2/Favorite_List/FavoriteList.dart';
import 'package:moyawim2/MainView/Contact.dart';
import 'package:moyawim2/MainView/Identity_determine.dart';
import 'package:moyawim2/MainView/MainView.dart';
import 'package:moyawim2/Profile_Page/Profile_Page_services.dart';
import 'package:moyawim2/Profile_Page/SizeConfig.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: IdentityDetermine(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
        ),
      ),
      body: MainView(),
    );
  }
}

class NavDrawer extends StatefulWidget {
  final identity;
  NavDrawer({
    this.identity,
  });

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  bool isEmpr = false;

  checkEmpr(userId) async {
    isEmpr = await DatabaseOperations(uid: userId).isEmployer();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    setState(() {
      checkEmpr(user.uid);
    });
    return StreamBuilder(
        stream: Firestore.instance
            .collection(widget.identity)
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Material(
              child: Center(
                child: Text(''),
              ),
            );
          } else {
            var userDoc = snapshot.data;
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePageEnum()));
                    },
                    child: DrawerHeader(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.cyanAccent,
                            Colors.cyan,
                            Colors.lightBlue
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.topLeft,
                        )),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            "assets/Logo-Moyawem.jpeg",
                                          ))),
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10)),
                                    Text(
                                      userDoc['name'] +
                                          " " +
                                          userDoc['lastname'],
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 45),
                                      child: Text(userDoc['phone number'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        )),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      size: 30,
                    ),
                    title: Text(
                      'الملف الشخصي',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutBuilder(
                                      builder: (context, constraints) {
                                    return OrientationBuilder(
                                      builder: (context, orientation) {
                                        SizeConfig()
                                            .init(constraints, orientation);
                                        return MaterialApp(
                                          debugShowCheckedModeBanner: false,
                                          title: 'HomeScreen App',
                                          home: ProfilePageEnum(),
                                        );
                                      },
                                    );
                                  })));
                    },
                  ),
                  isEmpr
                      ? ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 30,
                          ),
                          title: Text(
                            'لائحة المفضلين',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FavoriteList();
                            }));
                          },
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  ListTile(
                    leading: Icon(
                      Icons.supervisor_account,
                      size: 30,
                    ),
                    title: Text(
                      'تواصل معنا',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Contact()));
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 30,
                    ),
                    title: Text(
                      'تسجيل الخروج',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      AuthService().signOut(context);
                    },
                  ),
                ],
              ),
            );
          }
        });
  }
}
