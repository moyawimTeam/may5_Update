import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Authentication_services/authservice.dart';
import 'package:moyawim2/Loading/BlueLoading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //constants and variables we need in this page
  //for TextField
  final TextEditingController _controller = TextEditingController();
  //for background color of the page blue
  final Color backgroundColor = Color(0xff96D4FF);
  //the key for validation in TextField
  final _formKey = GlobalKey<FormState>();
  //for the auth function
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  bool isBox = false;
  bool loading = false;
  bool showError = false;
  void setVerId(String verId) {
    verificationId = verId;
  }

  void setCodeSent() {
    setState(() {
      codeSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? BlueLoading()
        : Form(
            key: _formKey,
            child: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 123,
                        ),
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/backup.png',
                          image:
                              'https://img.icons8.com/dusk/140/000000/sms.png',
                          height: 150,
                          width: 150,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Card(
                        elevation: 15,
                        child: Container(
                          height: 360,
                          width: 320,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 187,
                                  ),
                                  Text(
                                    'لبنان (961+)',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black54,
                                thickness: 0.5,
                                indent: 10,
                                endIndent: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: TextFormField(
                                  controller: _controller,
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.phone,
                                  textDirection: TextDirection.rtl,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: '. . . ادخل رقمك',
                                    hintStyle: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  validator: (val) => val.length != 8
                                      ? 'الرجاء التأكد من رقم الهاتف (8 أرقام)'
                                      : null,
                                  onChanged: (val) {
                                    setState(() {
                                      this.phoneNo = "+961" + val;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                    'سوف تصلك رسالة لتأكد'
                                    ' من أنك مالك الرقم',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              showError
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        'الرجاء المحاولة مجددا و التأكد من رقم الهاتف و كلمة المرور ',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20,
                                    ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: RaisedButton(
                                  elevation: 7.0,
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _controller.clear();
                                      bool alreadyRegistered =
                                          await AuthService().checkNb(phoneNo);
                                      if (alreadyRegistered) {
                                        setState(() {
                                          loading = true;
                                        });
                                        codeSent
                                            ? await AuthService().signInWithOTP(
                                                smsCode, verificationId)
                                            : await AuthService().verifyPhone(
                                                context,
                                                'login',
                                                phoneNo,
                                                setVerId,
                                                setCodeSent,
                                              );
                                        Timer(const Duration(seconds: 5), () {
                                          if (user == null) {
                                            setState(() {
                                              loading = false;
                                            });
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content: Text(
                                                          'الرجاء المحاولة مجددا'),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text('حسنا'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    ));
                                          }
                                        });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'الرجاء تسجيل حساب قبل محاولة الدخول',
                                                  textAlign: TextAlign.right,
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('حسنا'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                    }
                                  },
                                  color: Colors.blueAccent,
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    leading: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    trailing: Text(
                                      'دخول',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
//                              GestureDetector(
//                                onTap: () {
//                                  DataVar.takeMetoSignIn = false;
//                                },
//                                child: Text('sign up pages'),
//                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
