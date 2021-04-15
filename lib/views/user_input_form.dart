
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomForm extends StatefulWidget {
  final String hintText;

  MyCustomForm({Key key, @required this.hintText}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/ic_account.png')),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
