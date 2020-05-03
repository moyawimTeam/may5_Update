import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Database_Services/Database_services.dart';
import 'package:moyawim2/Profile_Page/Employee_Profile.dart';
import 'package:moyawim2/Profile_Page/SizeConfig.dart';
import 'package:moyawim2/Results_Page/Rating.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileBar extends StatefulWidget {
  final String job;
  final String desc;
  final String name;
  final String lastName;
  final String phoneNumber;
  final String city;
  final ratingNumber;
  final ratingValue;
  final String uid;
  final bool inFavoriteList;

  const ProfileBar({
    this.name,
    this.city,
    this.job,
    this.lastName,
    this.phoneNumber,
    this.desc,
    this.uid,
    this.ratingValue,
    this.ratingNumber,
    this.inFavoriteList,
  });

  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  String _databaseImage = '';
  bool imageExists = false;

  checkImage(userID) async {
    DocumentSnapshot ref = await Firestore.instance
        .collection('ProfileImages')
        .document(userID)
        .get();
    if (ref.exists) {
      setState(() {
        _databaseImage = ref.data['Profile'];
        imageExists = true;
      });
    }
  }

  final int rating = 0;
  bool isEmpr = true;
  checkEmpr(userId) async {
    isEmpr = await DatabaseOperations(uid: userId).isEmployer();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    checkEmpr(user.uid);
    checkImage(widget.uid);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LayoutBuilder(
                      builder: (context, constraints) {
                        return OrientationBuilder(
                          builder: (context, orientation) {
                            SizeConfig().init(constraints, orientation);
                            return MaterialApp(
                              debugShowCheckedModeBanner: false,
                              title: 'Employee Profile',
                              home: EmployeeProfile(
                                userId: widget.uid,
                                isMe: false,
                              ),
                            );
                          },
                        );
                      },
                    )));
      },
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('Employees')
              .document(widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return Card(
              child: Material(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Container(
                    height: 160,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: isEmpr
                                    ? PopupMenuButton(
                                        onSelected: (String result) {
                                        if (result == 'Add') {
                                          Firestore.instance
                                              .collection('Employees')
                                              .document(widget.uid)
                                              .updateData({
                                            user.uid: user.uid,
                                          });
                                        } else if (result == 'delete') {
                                          Firestore.instance
                                              .collection('Employees')
                                              .document(widget.uid)
                                              .updateData({
                                            user.uid: FieldValue.delete(),
                                          }).whenComplete(() =>
                                                  print('Delete Completed'));
                                        }
                                      }, itemBuilder: (BuildContext context) {
                                        return <PopupMenuEntry<String>>[
                                          widget.inFavoriteList
                                              ? PopupMenuItem(
                                                  value: 'delete',
                                                  child: Text(
                                                      'حذف من قائمة المفضلين'),
                                                )
                                              : PopupMenuItem(
                                                  value: 'Add',
                                                  child: Text(
                                                      ' اضف إلى قائمة المفضلين '),
                                                ),
                                        ];
                                      })
                                    : Container(),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 10,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    String phoneNumber = widget.phoneNumber;
                                    var whatsAppUrl =
                                        "whatsapp://send?phone=$phoneNumber";
                                    if (await canLaunch(whatsAppUrl)) {
                                      await launch(whatsAppUrl);
                                    } else {
                                      throw 'Could not launch $whatsAppUrl';
                                    }
                                  },
                                  child: FaIcon(FontAwesomeIcons.whatsapp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    height: 2,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.name + " " + widget.lastName,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 25,
                                    ),
                                  ),
                                  flex: 3,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          " " + widget.job,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Icon(Icons.build)
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          " " + widget.city,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.blueAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      user.uid != widget.uid
                                          ? showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Rating(
                                                  uid: widget.uid,
                                                );
                                              },
                                            )
                                          : null;
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text("(" +
                                            widget.ratingNumber.toString() +
                                            ")"),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: List.generate(5, (index) {
                                              return Icon(
                                                index < 5 - widget.ratingValue
                                                    ? Icons.star_border
                                                    : Icons.star,
                                                color: Colors.amber,
                                              );
                                            })),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 4,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: Image.network(imageExists
                                        ? _databaseImage
                                        : 'https://images.macrumors.com/t/XjzsIpBxeGphVqiWDqCzjDgY4Ck=/800x0/article-new/2019/04/guest-user-250x250.jpg'),
                                  ),
                                  flex: 6,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
