import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moyawim2/Authentication_services/User.dart';
import 'package:moyawim2/Loading/loading.dart';
import 'package:moyawim2/Results_Page/Result_Profile_Widget.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatefulWidget {
  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
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
      inFavoriteList: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool loading = false;
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Row(
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'قائمة المفضلين',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
      body: loading
          ? Loading()
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('Employees')
                  .where(user.uid, isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Material(
                    child: Loading(),
                  );
                } else if (snapshot.data.documents.length == 0) {
                  return Center(
                      child: const Text(
                    "لا مياومون حاليا",
                    style: TextStyle(fontSize: 50),
                  ));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildProfileWidgets(
                            context, snapshot.data.documents[index]),
                  );
                }
              },
            ),
    );
  }
}
