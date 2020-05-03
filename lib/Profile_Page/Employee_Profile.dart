import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Edit_Profile/edit_profile.dart';
import 'package:moyawim2/Loading/loading.dart';
import 'package:moyawim2/Profile_Page/SizeConfig.dart';
import 'package:moyawim2/Results_Page/Rating.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeProfile extends StatefulWidget {
  final userId;
  final isMe;
  const EmployeeProfile({
    this.userId,
    this.isMe,
  });
  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  String _databaseImage = '';
  bool imageExists = false;
  int _imagesNb;
  bool employeeImages = false;

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

  checkNb() async {
    DocumentSnapshot img = await Firestore.instance
        .collection('Images')
        .document(widget.userId)
        .get();
    if (img.exists) {
      var nb = img.data['numberImages'];
      nb == null ? _imagesNb = 0 : _imagesNb = nb;
    }
  }

  checkImagesExist() async {
    DocumentSnapshot img = await Firestore.instance
        .collection('Images')
        .document(widget.userId)
        .get();
    employeeImages = img.exists;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    checkImage(widget.userId);
    checkImagesExist();
    checkNb();
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Employees')
          .document(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        var userDocument = snapshot.data;
        return !snapshot.hasData
            ? Loading()
            : Scaffold(
                floatingActionButton: user.uid != widget.userId
                    ? FloatingActionButton(
                        child: FaIcon(FontAwesomeIcons.whatsapp),
                        onPressed: () async {
                          String phoneNumber = userDocument['phone number'];
                          var whatsAppUrl =
                              "whatsapp://send?phone=$phoneNumber";
                          if (await canLaunch(whatsAppUrl)) {
                            await launch(whatsAppUrl);
                          } else {
                            throw 'Could not launch $whatsAppUrl';
                          }
                        },
                        backgroundColor: Colors.green,
                      )
                    : null,
                backgroundColor: Color(0xffF8F8FA),
                body: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    child: Image.network(imageExists
                                        ? _databaseImage
                                        : 'https://images.macrumors.com/t/XjzsIpBxeGphVqiWDqCzjDgY4Ck=/800x0/article-new/2019/04/guest-user-250x250.jpg'),
                                  ),
                                ));
                      },
                      child: Container(
                        height: 300,
                        child: Container(
                          //profile picture
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(
                              imageExists
                                  ? _databaseImage
                                  : 'https://images.macrumors.com/t/XjzsIpBxeGphVqiWDqCzjDgY4Ck=/800x0/article-new/2019/04/guest-user-250x250.jpg',
                            ),
                            fit: BoxFit.cover,
                          )),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 35 * SizeConfig.heightMultiplier, bottom: 7),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              topLeft: Radius.circular(30.0),
                            )),
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            userId: widget.userId,
                                            type: 'Employees',
                                          )));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            userDocument['name'] +
                                                " " +
                                                userDocument['lastname'],
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontSize: 40,
                                            ),
                                          ),
                                        ])),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            userDocument['city'],
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            textDirection: TextDirection.rtl,
                                            color: Colors.blueAccent,
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text(
                                            userDocument['job'],
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ])),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            userDocument['phone number'],
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 30),
                                          ),
                                        ])),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    !widget.isMe
                                        ? showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Rating(
                                                uid: widget.userId,
                                              );
                                            },
                                          )
                                        : print('test');
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text('(' +
                                          userDocument['rating']
                                                  ['rating number']
                                              .toString() +
                                          ')'),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              index <
                                                      5 -
                                                          userDocument['rating']
                                                              ['rating value']
                                                  ? Icons.star_border
                                                  : Icons.star,
                                              color: Colors.amber,
                                              size: 50,
                                            );
                                          })),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                widget.isMe
                                    ? RaisedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile(
                                                        userId: user.uid,
                                                        type: 'Employees',
                                                      )));
                                        },
                                        elevation: 15,
                                        color: Colors.grey[600],
                                        child: Text(
                                          'تعديل الملف الشخصي',
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Divider(
                                  color: Colors.grey,
                                  height: 50,
                                  indent: 10.0,
                                  endIndent: 10.0,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          child: Text(
                                              "الوصف:  " +
                                                  userDocument['description'],
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.2 *
                                                      SizeConfig
                                                          .textMultiplier)),
                                          padding: EdgeInsets.all(8),
                                        ),
                                      )
                                    ]),
                                Divider(
                                  color: Colors.grey,
                                  height: 50,
                                  indent: 10.0,
                                  endIndent: 10.0,
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        right: 20.0,
                                        top: 2 * SizeConfig.heightMultiplier),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "الأعمال ",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 2.2 *
                                                    SizeConfig.textMultiplier),
                                          ),
                                        ])),
                                Container(
                                    height: 300,
                                    child: employeeImages
                                        ? StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('Images')
                                                .document(widget.userId)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child: const Text(
                                                  "لا مياومون حاليا",
                                                  style:
                                                      TextStyle(fontSize: 50),
                                                ));
                                              } else {
                                                return ListView.builder(
                                                  itemCount: _imagesNb,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    int value = index + 1;
//                                                  return Center(
//                                                      child: Text('$index'));
                                                    return Image.network(
                                                        snapshot.data[
                                                                '$value'] ??
                                                            '');
                                                  },
                                                );
                                              }
                                            },
                                          )
                                        : Container()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
