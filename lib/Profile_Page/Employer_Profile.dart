import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moyawim2/Edit_Profile/edit_profile.dart';
import 'package:moyawim2/Loading/loading.dart';

class EmployerProfile extends StatefulWidget {
  final userId;
  final isMe;
  const EmployerProfile({
    this.userId,
    this.isMe,
  });
  @override
  _EmployerProfileState createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<EmployerProfile> {
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

  @override
  Widget build(BuildContext context) {
    checkImage(widget.userId);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Employers')
          .document(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        var userDocument = snapshot.data;
        return !snapshot.hasData
            ? Loading()
            : Scaffold(
                backgroundColor: Colors.white,
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
                        top: 310,
                        bottom: 7,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            userId: widget.userId,
                                            type: 'Employers',
                                          )));
                            },
                            child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                widget.isMe
                                    ? RaisedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile(
                                                        userId: widget.userId,
                                                        type: 'Employers',
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
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Container(
//                                padding: EdgeInsets.all(8),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            userDocument['name'] +
                                                " " +
                                                userDocument['lastname'],
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            'الاسم: ',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ]),
                                    decoration: BoxDecoration(
                                        color: Colors.blue[400],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            userDocument['phone number'],
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                            ),
                                          ),
                                          Text(
                                            'رقم الهاتف: ',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ]),
                                    decoration: BoxDecoration(
                                        color: Colors.blue[400],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Container(
//                                padding: EdgeInsets.all(5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            userDocument['city'],
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            'المدينة: ',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ]),
                                    decoration: BoxDecoration(
                                        color: Colors.blue[400],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                Divider(
                                  height: 5,
//                                thickness: 1,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            userDocument['description'],
                                            style: TextStyle(
                                              fontSize: 27,
                                              color: Colors.white,
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(
                                          'التعريف: ',
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.blue[400],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
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
