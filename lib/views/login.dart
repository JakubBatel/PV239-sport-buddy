import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sport_buddy/components/gradient_button.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: AssetImage('assets/logo.png')),
        SizedBox(height: 30),
        SignInButton(
          Buttons.Google,
          text: "Sign up with Google",
          onPressed: () {},
        ),
        SignInButton(
          Buttons.Facebook,
          text: "Sign up with Facebook",
          onPressed: () {},
        ),
        SizedBox(height: 10),
        Text("OR"),
        SizedBox(height: 10),
        MyCustomForm(
          hintText: "Username",
        ),
        MyCustomForm(
          hintText: "Password",
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: GradientButton(
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Create account",
              style: TextStyle(color: Colors.red),
            ),
            Text(
              "Forgot password",
              style: TextStyle(color: Colors.red),
            )
          ],
        )
      ],
    );
  }
}

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
