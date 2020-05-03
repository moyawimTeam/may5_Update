import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moyawim2/Loading/loading.dart';
import 'package:moyawim2/Results_Page/Result_Profile_Widget.dart';

class ResultsPage extends StatefulWidget {
  final String city;
  final String job;
  const ResultsPage({
    this.city,
    this.job,
  });

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  Widget _buildProfileWidgets(BuildContext context, DocumentSnapshot document) {
    return ProfileBar(
      name: document['name'],
      lastName: document['lastname'],
      phoneNumber: document['phone number'],
      job: document['job'],
      desc: document['description'],
      city: document['city'],
      uid: document.documentID,
      ratingNumber: document['rating']['rating number'],
      ratingValue: document['rating']['rating value'],
      inFavoriteList: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder(
        stream: widget.city == 'غير محدد'
            ? Firestore.instance
                .collection('Employees')
                .where('job', isEqualTo: widget.job)
                .snapshots()
            : Firestore.instance
                .collection('Employees')
                .where('city', isEqualTo: widget.city)
                .where('job', isEqualTo: widget.job)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else if (snapshot.data.documents.length == 0) {
            return Material(
              child: Center(
                child: Text(
                  'لا مياومون حاليا',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 80,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildProfileWidgets(context, snapshot.data.documents[index]),
            );
          }
        },
      ),
    );
  }
}
