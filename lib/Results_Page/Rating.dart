import 'package:flutter/material.dart';
import 'package:moyawim2/Database_Services/Database_services.dart';

class Rating extends StatefulWidget {
  final String uid;
  const Rating({
    this.uid,
  });
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "ادخل تقييمك ",
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
      ),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: value >= 5
                  ? Icon(
                      Icons.star,
                      size: 45,
                      color: Colors.amber,
                    )
                  : Icon(
                      Icons.star_border,
                      size: 45,
                    ),
              onPressed: () {
                setState(() {
                  value = 5;
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: value >= 4
                  ? Icon(
                      Icons.star,
                      size: 45,
                      color: Colors.amber,
                    )
                  : Icon(
                      Icons.star_border,
                      size: 45,
                    ),
              onPressed: () {
                setState(() {
                  value = 4;
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: value >= 3
                  ? Icon(
                      Icons.star,
                      size: 45,
                      color: Colors.amber,
                    )
                  : Icon(
                      Icons.star_border,
                      size: 45,
                    ),
              onPressed: () {
                setState(() {
                  value = 3;
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: value >= 2
                  ? Icon(
                      Icons.star,
                      size: 45,
                      color: Colors.amber,
                    )
                  : Icon(
                      Icons.star_border,
                      size: 45,
                    ),
              onPressed: () {
                setState(() {
                  value = 2;
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: value >= 1
                  ? Icon(
                      Icons.star,
                      size: 45,
                      color: Colors.amber,
                    )
                  : Icon(
                      Icons.star_border,
                      size: 45,
                    ),
              onPressed: () {
                setState(() {
                  value = 1;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("إلغاء"),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("تأكيد"),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () async {
            var myUid = await DatabaseOperations().getCurrentUser();
            await DatabaseOperations(uid: myUid)
                .updateRating(value, widget.uid, context, myUid);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
