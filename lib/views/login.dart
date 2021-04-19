import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/screens/main_screen.dart';
import 'package:sport_buddy/views/user_input_form.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/logo.png')),
          SizedBox(height: 30),
          SignInButton(
            Buttons.Google,
            text: "Sign up with Google",
            onPressed: () {
              final credential = signInWithGoogle();
              credential.then((cred) async {
                if (cred.user != null) {
                  userCubit.updateUserName(cred.user.displayName);
                  final uid = FirebaseAuth.instance.currentUser.uid;
                  print(uid);
                  userCubit.setUserID(uid);
                  userCubit.setPicture();
                  _openMainScreen(context);
                }
              });
            },
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
                    onPressed: () {
                      _openMainScreen(context);
                    },
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
      ),
    );
  }
}

void _openMainScreen(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (ctx) => BlocProvider.value(
              value: BlocProvider.of<UserCubit>(context),
              child: MainScreen())));
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );



  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);


}
