import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, Function action, String description) {

  // set up the buttons
  Widget cancelButton = MaterialButton(
    child: Text("Cancel"),
    onPressed:  () {Navigator.of(context).pop();}
  );
  Widget continueButton = MaterialButton(
    child: Text("Continue"),
    onPressed:  () {
      Navigator.of(context).pop();
      action();
    }
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirmation"),
    content: Text(description),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}