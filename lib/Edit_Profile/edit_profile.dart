import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moyawim2/Constants_Data/Data.dart';
import 'package:moyawim2/Loading/loading.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  final userId;
  final type;
  const EditProfile({
    this.userId,
    this.type,
  });
  @override
  State createState() => type == 'Employees'
      ? new EditEmployeeProfile()
      : new EditEmployerProfile();
}

class EditEmployeeProfile extends State<EditProfile> {
  File _image;
  File _workImage;
  File croppedFile;
  String _databaseImage = '';
  bool imageExists = false;
  bool loading = false;
  String firstname;
  String lastname;
  String desc;
  String city;
  String job;
  int _ImagesNb;
  bool employeeImages = false;
  int currentImageNumber;
  bool imageIsHere = false;
  bool isUploading = false;
  bool isUploadingProf = false;
  StorageUploadTask uploadTask;

  checkNb() async {
    DocumentSnapshot img = await Firestore.instance
        .collection('Images')
        .document(widget.userId)
        .get();
    var nb = img.data['numberImages'];
    nb == null ? _ImagesNb = 0 : _ImagesNb = nb;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    cropProfile(image);
  }

  Future getWorkImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    cropImage(image);
  }

  setValues(type) async {
    DocumentSnapshot ref =
        await Firestore.instance.collection(type).document(widget.userId).get();
    final userDoc = ref.data;
    firstname = userDoc['name'];
    lastname = userDoc['lastname'];
    desc = userDoc['description'];
    city = userDoc['city'];
    job = userDoc['job'];
  }

  Future uploadPic(BuildContext context, userID) async {
    setState(() {
      isUploadingProf = true;
    });
    String fileName = basename(_image.path);
    print("this is filename: $fileName");
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putFile(_image);
    await uploadTask.onComplete;
    setState(() {
      isUploadingProf = false;
    });
    String imageURL = await ref.getDownloadURL();
    Firestore.instance.collection('ProfileImages').document(userID).setData({
      'Profile': imageURL,
    });
    print(imageURL);
  }

  Future uploadWorkPic(BuildContext context, userID, myImage) async {
    setState(() {
      isUploading = true;
    });
    String fileName = basename(myImage.path);
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    uploadTask = ref.putFile(myImage);
    await uploadTask.onComplete;
    setState(() {
      isUploading = false;
    });
    String imageURL = await ref.getDownloadURL();
    DocumentSnapshot img =
        await Firestore.instance.collection('Images').document(userID).get();
    if (img.exists) {
      var nb = img.data['numberImages'];
      if (nb != null) {
        if (nb > 3) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('لا يمكنك إضافة أكثر من أربعة صور'),
                    actions: [
                      FlatButton(
                        child: Text('حسنا'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ));
        } else {
          for (int i = 1; i < 5; i++) {
            if (img.data['$i'] == null) {
              var value = nb + 1;
              Firestore.instance
                  .collection('Images')
                  .document(userID)
                  .updateData({
                '$i': imageURL,
                'numberImages': value,
              });
              break;
            }
          }
        }
      } else {
        Firestore.instance.collection('Images').document(userID).setData({
          'numberImages': 1,
          '1': imageURL,
          '2': null,
          '3': null,
          '4': null,
        });
      }
    } else {
      Firestore.instance.collection('Images').document(userID).setData({
        'numberImages': 1,
        '1': imageURL,
        '2': null,
        '3': null,
        '4': null,
      });
    }
    print(imageURL);
  }

  Future<void> cropProfile(imageFile) async {
    croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
    );
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }

  Future<void> cropImage(imageFile) async {
    croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    if (croppedFile != null) {
      setState(() {
        _workImage = croppedFile;
      });
    }
  }

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

  checkImagesExist() async {
    DocumentSnapshot img = await Firestore.instance
        .collection('Images')
        .document(widget.userId)
        .get();
    employeeImages = img.exists;
  }

  @override
  void initState() {
    super.initState();
    setValues('Employees');
  }

  String val1;
  @override
  Widget build(BuildContext context) {
    getJobs();
    checkNb();
    checkImage(widget.userId);
    checkImagesExist();
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Employees')
            .document(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            var userDoc = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                centerTitle: true,
                title: Text("تعديل", textDirection: TextDirection.rtl),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      uploadPic(context, widget.userId);
                      Firestore.instance
                          .collection('Employees')
                          .document(widget.userId)
                          .updateData({
                        'name': firstname,
                        'lastname': lastname,
                        'description': desc,
                        'city': city,
                        'job': job,
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              body: loading
                  ? Loading()
                  : ListView(
//                crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 40),
                          child: FutureBuilder(
                            builder: (context, snapshot) => Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  isUploadingProf
                                      ? Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: CircularProgressIndicator(),
                                        )
                                      : _image == null
                                          ? CircleAvatar(
                                              radius: 60,
                                              backgroundImage: NetworkImage(
                                                  imageExists
                                                      ? _databaseImage
                                                      : 'https://images.macrumors.com/t/XjzsIpBxeGphVqiWDqCzjDgY4Ck=/800x0/article-new/2019/04/guest-user-250x250.jpg'),
                                              backgroundColor:
                                                  Colors.transparent,
                                            )
                                          : CircleAvatar(
                                              radius: 60,
                                              backgroundImage:
                                                  FileImage(_image),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () {
                                      getImage();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "تعديل الصورة",
                            style: TextStyle(
                                fontSize: 20, color: Colors.blueAccent),
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: <Widget>[
                            InputInfo(
                              initialValue: userDoc['name'],
                              hint: 'الاسم',
                              fun: (String val) {
                                setState(() {
                                  firstname = val;
                                });
                              },
                              valid: (value) {
                                if (value.length == 0) {
                                  return 'الرجاء إدخال رقم الهاتف(8 أرقام)';
                                }
                                return null;
                              },
                            ),
                            InputInfo(
                              initialValue: userDoc['lastname'],
                              hint: 'الشهرة',
                              fun: (val) {
                                setState(() {
                                  lastname = val;
                                });
                              },
                              valid: (value) {
                                if (value.length == 0) {
                                  return 'الرجاء إدخال رقم الهاتف(8 أرقام)';
                                }
                                return null;
                              },
                            ),
                            InputInfo(
                              initialValue: userDoc['description'],
                              hint: 'التعريف',
                              fun: (val) {
                                setState(() {
                                  desc = val;
                                });
                              },
                              valid: (value) {
                                if (value.length == 0) {
                                  return 'الرجاء إدخال رقم الهاتف(8 أرقام)';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DropdownButton(
                                      items: jobsList.map((var dropItems) {
                                        return DropdownMenuItem(
                                            value: dropItems,
                                            child: Text(dropItems));
                                      }).toList(),
                                      onChanged: (var item) {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          job = item;
                                        });
                                      },
                                      value: job),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DropdownButton(
                                      items: cities.map((var dropItems) {
                                        return DropdownMenuItem(
                                            value: dropItems,
                                            child: Text(dropItems));
                                      }).toList(),
                                      onChanged: (var item) {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          city = item;
                                        });
                                      },
                                      value: city),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () async {
                                          getWorkImage();
                                        },
                                      ),
                                      Text("هل لديك صور لأعمالك؟ أضفها"),
                                    ])),
                            Column(
                              children: [
                                isUploading
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(),
                                      )
                                    : Container(),
                                _workImage != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.cancel),
                                                  onPressed: () {
                                                    setState(() {
                                                      _workImage = null;
                                                      imageIsHere = true;
                                                    });
                                                  },
                                                ),
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.cloud_upload),
                                                  onPressed: () {
                                                    uploadWorkPic(
                                                        context,
                                                        widget.userId,
                                                        croppedFile != null
                                                            ? croppedFile
                                                            : _workImage);
                                                    _workImage = null;
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.crop),
                                                  onPressed: () {
                                                    cropImage(_workImage);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              height: 300,
                                              width: 300,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(_workImage),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Container(
                                    height: 300,
                                    child: !employeeImages
                                        ? Container()
                                        : StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('Images')
                                                .document(widget.userId)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child: const Text(
                                                  "",
                                                  style:
                                                      TextStyle(fontSize: 50),
                                                ));
                                              } else {
                                                return ListView.builder(
                                                  itemCount: _ImagesNb,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    int value = index + 1;
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                  Icons.delete),
                                                              iconSize: 35,
                                                              onPressed: () {
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Images')
                                                                    .document(widget
                                                                        .userId)
                                                                    .updateData({
                                                                  '$value':
                                                                      null,
                                                                  'numberImages':
                                                                      _ImagesNb -
                                                                          1,
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 8,
                                                            child: Image.network(
                                                                snapshot.data[
                                                                        '$value'] ??
                                                                    ''),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          )),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
            );
          }
        });
  }
}

class InputInfo extends StatelessWidget {
  const InputInfo({
    Key key,
    @required this.initialValue,
    @required this.hint,
    @required this.fun,
    @required this.valid,
  }) : super(key: key);

  final initialValue;
  final hint;
  final Function fun;
  final Function valid;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: TextFormField(
            validator: valid,
            onChanged: fun,
            initialValue: initialValue,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey))));
  }
}

class EditEmployerProfile extends State<EditProfile> {
  File _image;
  String _databaseImage = '';
  bool imageExists = false;
  bool loading = false;
  File croppedFile;
  bool isUploadingProf = false;

  String firstname;
  String lastname;
  String desc;
  String city;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    cropProfile(image);
  }

  Future<void> cropProfile(imageFile) async {
    croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
    );
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }

  setValues(type) async {
    DocumentSnapshot ref =
        await Firestore.instance.collection(type).document(widget.userId).get();
    final userDoc = ref.data;
    firstname = userDoc['name'];
    lastname = userDoc['lastname'];
    desc = userDoc['description'];
    city = userDoc['city'];
  }

  Future uploadPic(BuildContext context, userID) async {
    setState(() {
      isUploadingProf = true;
    });
    String fileName = basename(_image.path);
    print("this is filename: $fileName ${DateTime.now()}");
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putFile(_image);
    await uploadTask.onComplete;
    setState(() {
      isUploadingProf = false;
    });
    String imageURL = await ref.getDownloadURL();
    Firestore.instance.collection('ProfileImages').document(userID).setData({
      'Profile': imageURL,
    });
    print(imageURL);
  }

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
  void initState() {
    super.initState();
    setValues('Employers');
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
          if (!snapshot.hasData) {
            return Loading();
          } else {
            var userDoc = snapshot.data;
            return Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: AppBar(
                  backgroundColor: Colors.blueAccent,
                  centerTitle: true,
                  title: Text("تعديل الصفحة الشخصية",
                      textDirection: TextDirection.rtl),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        uploadPic(context, widget.userId);
                        Firestore.instance
                            .collection('Employers')
                            .document(widget.userId)
                            .updateData({
                          'name': firstname,
                          'lastname': lastname,
                          'description': desc,
                          'city': city,
                        });
                      },
                    ),
                  ],
                ),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            isUploadingProf
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : _image == null
                                    ? CircleAvatar(
                                        radius: 60,
                                        backgroundImage: NetworkImage(imageExists
                                            ? _databaseImage
                                            : 'https://images.macrumors.com/t/XjzsIpBxeGphVqiWDqCzjDgY4Ck=/800x0/article-new/2019/04/guest-user-250x250.jpg'),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : CircleAvatar(
                                        radius: 60,
                                        backgroundImage: FileImage(_image),
                                        backgroundColor: Colors.transparent,
                                      ),
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                getImage();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "تعديل الصورة",
                        style:
                            TextStyle(fontSize: 20, color: Colors.blueAccent),
                      ),
                      SizedBox(height: 10),
                      ListView(shrinkWrap: true, children: <Widget>[
                        InputInfo(
                          initialValue: userDoc['name'],
                          hint: 'الاسم',
                          fun: (String val) {
                            setState(() {
                              firstname = val;
                            });
                          },
                          valid: (value) {
                            if (value.length == 0) {
                              return 'الرجاء إدخال الاسم';
                            }
                            return null;
                          },
                        ),
                        InputInfo(
                          initialValue: userDoc['lastname'],
                          hint: 'الشهرة',
                          fun: (String val) {
                            setState(() {
                              lastname = val;
                            });
                          },
                          valid: (value) {
                            if (value.length == 0) {
                              return 'الرجاء إدخال الشهرة';
                            }
                            return null;
                          },
                        ),
                        InputInfo(
                          initialValue: userDoc['description'],
                          hint: 'التعريف',
                          fun: (String val) {
                            setState(() {
                              desc = val;
                            });
                          },
                          valid: (value) {
                            if (value.length == 0) {
                              return 'الرجاء إدخال التعريف';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton(
                                  items: cities.map((var dropItems) {
                                    return DropdownMenuItem(
                                        value: dropItems,
                                        child: Text(dropItems));
                                  }).toList(),
                                  onChanged: (var item) {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      city = item;
                                    });
                                  },
                                  value: city),
                            ],
                          ),
                        ),
                      ])
                    ]));
          }
        });
  }
}
