import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moyawim2/Constants_Data/Data.dart';
import 'package:moyawim2/Loading/loading.dart';
import 'package:moyawim2/Results_Page/Results_Page.dart';
import 'package:moyawim2/Results_Page/Search_Page.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => new _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                await getJobs();
                showSearch(context: context, delegate: Data());
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('ابحث...',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0)),
                    SizedBox(width: 10.0),
                    Icon(Icons.search,
                        color: Colors.white,
                        size: 35.0,
                        textDirection: TextDirection.rtl)
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                padding: EdgeInsets.only(top: 17, left: 15),
                height: MediaQuery.of(context).size.height - 145,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0),
                    )),
                child: ListView(
                  children: <Widget>[
                    Category(
                      heading: 'خدمات منزلية',
                      databaseCategory: 'HomeServices',
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 30,
                      //indent: 10.0,
                      endIndent: 12.0,
                    ),
                    Category(
                      heading: 'خدمات صحية',
                      databaseCategory: 'HealthServices',
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 30,
                      //indent: 10.0,
                      endIndent: 12.0,
                    ),
                    Category(
                      heading: 'صيانة سيارات',
                      databaseCategory: 'CarServices',
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 30,
                      //indent: 10.0,
                      endIndent: 12.0,
                    ),
                    Category(
                      heading: 'خدمات أخرى',
                      databaseCategory: 'OtherServices',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final heading;
  final databaseCategory;
  const Category({
    this.heading,
    this.databaseCategory,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.only(right: 20.0, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    heading,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ])),
        Container(
            padding: EdgeInsets.only(right: 10),
            height: 220,
            child: StreamBuilder(
              stream:
                  Firestore.instance.collection(databaseCategory).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                } else {
                  return ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return myJobs(context, snapshot.data.documents[index]);
                      });
                }
              },
            )),
      ],
    );
  }
}

Column myJobs(BuildContext context, DocumentSnapshot document) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Expanded(
      flex: 10,
      child: GestureDetector(
        onTap: () {
          print(document.documentID);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultsPage(
                        job: document.documentID,
                        city: 'غير محدد',
                      )));
        },
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: //ListTile(
                  Image.network(
                      document['image'] ??
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/1024px-Solid_white.svg.png',
                      fit: BoxFit.cover),
            )),
      ),
    ),
    Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          document.documentID,
          textDirection: TextDirection.rtl, //textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
    ),
    Expanded(
        flex: 1,
        child: SizedBox(
          height: 20,
        )),
  ]);
}
