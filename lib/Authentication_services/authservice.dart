import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Database_Services/Database_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //This function checks continuously on the Login Page if the user is registered or not
  //and when he is registered it takes him to the desired page.
//  handleAuth() {
//    return StreamBuilder(
//        stream: FirebaseAuth.instance.onAuthStateChanged,
//        builder: (BuildContext context, snapshot) {
//          if (snapshot.hasData) {
//            return ResultsPage(
//              city: 'All',
//            ); //Here is the desired Page
//          } else {
//            return Intro(); //Here is the beginning Page
//          }
//        });
//  }

  //Sign out
  signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  //SignInWithOTP
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
    print("this is what is being done");
  }

  createEmployer(String firstname, String lastname, String phonenb,
      AuthCredential authCreds) async {
    try {
      AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(authCreds);
      FirebaseUser user = result.user;
      await DatabaseOperations(uid: user.uid)
          .updateEmployerData(firstname, lastname, phonenb);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  createEmployee(String firstname, String lastname, String phonenb, String job,
      String city, String desc, AuthCredential authCreds) async {
    try {
      AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(authCreds);
      FirebaseUser user = result.user;
      await DatabaseOperations(uid: user.uid)
          .updateEmployeeData(firstname, lastname, job, city, phonenb, desc);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //If google didn't handle automatic login this function gets called
  Future<void> verifyPhone(BuildContext context, String signInType, phoneNo,
      Function setVerId, Function setCodeSent,
      [firstname, lastname, job, city, desc]) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authCredential) {
      if (signInType == 'login') {
        AuthService().signIn(authCredential);
        Navigator.pop(context);
      } else if (signInType == 'signupEmpr') {
        AuthService()
            .createEmployer(firstname, lastname, phoneNo, authCredential);
      } else if (signInType == 'signupEmpl') {
        AuthService().createEmployee(
            firstname, lastname, phoneNo, job, city, desc, authCredential);
      }
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      setVerId(verId);
      setCodeSent();
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      setVerId(verId);
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Future<bool> checkNb(String phoneNb) async {
    DocumentSnapshot ds = await Firestore.instance
        .collection("PhoneNumbers")
        .document(phoneNb)
        .get();
    return ds.exists;
  }
}
