import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, Function action, String description) {
  // set up the buttons
  Widget cancelButton = MaterialButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      });
  Widget continueButton = MaterialButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        action();
      });

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

showErrorDialog(BuildContext context, String description) {
  // set up the buttons
  Widget cancelButton = MaterialButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(description),
    actions: [
      cancelButton,
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

showSnackbar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Theme.of(context).errorColor,
  ));
}
