import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/User.dart';

class DatabaseOperations {
  final String uid;
  DatabaseOperations({this.uid});

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return FirebaseAuth.instance.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  getCurrentUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<bool> isEmployer() async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Employers").document(uid).get();
    return ds.exists;
  }

  Future<bool> hasRated(String employeeId, String uid) async {
    DocumentSnapshot ds = await Firestore.instance
        .collection('Employees')
        .document(employeeId)
        .get();
    try {
      int userRated = ds.data['rating']['Employers']['$uid'];
      if (userRated != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateEmployeeData(String firstname, String lastname, String job,
      String city, String phonenb, String description) async {
    final CollectionReference jobCollection =
        Firestore.instance.collection('Employees');
    final CollectionReference phoneNumber =
        Firestore.instance.collection('PhoneNumbers');
    await jobCollection.document(uid).setData({
      'name': firstname,
      'lastname': lastname,
      'phone number': phonenb,
      'description': description,
      'job': job,
      'city': city,
      'rating': {
        'rating number': 0,
        'rating value': 0,
        'Employers': {},
      },
    });
    await phoneNumber.document(phonenb).setData({});
  }

  Future updateEmployerData(
      String firstname, String lastname, String phonenb) async {
    final CollectionReference jobCollection =
        Firestore.instance.collection('Employers');
    final CollectionReference phoneNumber =
        Firestore.instance.collection('PhoneNumbers');
    await jobCollection.document(uid).setData({
      'name': firstname,
      'lastname': lastname,
      'phone number': phonenb,
    });
    await phoneNumber.document(phonenb).setData({});
  }

  Future updateRating(int ratingValue, String employeeId, BuildContext context,
      String uid) async {
    bool isEmpr = await isEmployer();
    print(isEmpr);
    bool alreadyRated = await hasRated(employeeId, uid);
    print(alreadyRated);
    void updateData() async {
      final CollectionReference jobCollection =
          Firestore.instance.collection('Employees');
      DocumentSnapshot doc = await jobCollection.document(employeeId).get();
      var ratingNumber = await doc.data['rating']['rating number'];
      var currentRatingValue = await doc.data['rating']['rating value'];
      await jobCollection.document(employeeId).updateData({
        'rating': {
          'rating number': ratingNumber + 1,
          'rating value': (currentRatingValue * ratingNumber + ratingValue) /
              (ratingNumber + 1),
          'Employers': {
            uid: ratingValue,
          }
        },
      });
    }

    if (isEmpr && !alreadyRated) {
      updateData();
    } else if (isEmpr && alreadyRated) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'لقد قمت بتقييم هذا المياوم هل تريد التغيير ؟',
                textAlign: TextAlign.right,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('نعم'),
                  onPressed: () async {
                    final CollectionReference jobCollection =
                        Firestore.instance.collection('Employees');
                    DocumentSnapshot doc =
                        await jobCollection.document(employeeId).get();
                    var ratingNumber =
                        await doc.data['rating']['rating number'];
                    print(ratingNumber);
                    var currentRatingValue =
                        await doc.data['rating']['rating value'];
                    print(currentRatingValue);
                    var previousRating =
                        await doc.data['rating']['Employers']['$uid'];
                    print(previousRating);
                    var newRating =
                        (ratingNumber * currentRatingValue - previousRating) /
                            (ratingNumber);
                    print(newRating);
                    var avgRating =
                        ((newRating * (ratingNumber - 1) + ratingValue) /
                            (ratingNumber));
                    print(avgRating);
                    await jobCollection.document(employeeId).updateData({
                      'rating': {
                        'rating number': ratingNumber,
                        'rating value': avgRating,
                        'Employers': {
                          uid: ratingValue,
                        }
                      },
                    });
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('كلا'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'المياوموون لا يمكنهم تقييم مياومون أخرون '
                'عليك أن تكون صاحب عمل لتتمكن من التقييم ',
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
}
