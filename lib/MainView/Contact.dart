import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final myController = TextEditingController();
    final snackBar = SnackBar(content: Text('لقد تم استلام رسالتك بنجاح'));
    String message;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تواصل معنا'),
          centerTitle: true,
          backgroundColor: Colors.blue[500],
        ),
        body: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 500,
                  child: TextFormField(
                    onChanged: (String val) {
                      message = val;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'ألرجاء كتابة رسالة قبل محاولة إرسالها';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 17,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك',
                      hintStyle: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        await Firestore.instance
                            .collection('Reported_Issues')
                            .document()
                            .setData({
                          'review': message,
                        });
                        myController.clear();
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          'إرسال',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
