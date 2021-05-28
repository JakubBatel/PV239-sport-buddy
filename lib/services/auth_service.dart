import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/user_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithFacebook() async {
    try {
      final AccessToken result = await FacebookAuth.instance.login();

      if (result == null) {
        return null;
      }

      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  static Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<UserModel> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final userModel = await UserService.fetchUser(user.uid);
    if (userModel == null) {
      var name = FirebaseAuth.instance.currentUser.displayName;
      if (name == null) {
        name = FirebaseAuth.instance.currentUser.email;
      }
      if (name == null) {
        name = 'User';
      }

      return await UserService.addUser(
        UserModel(
          id: null,
          name: name,
          profilePicture: user.photoURL,
        ),
      );
    }
    return userModel;
  }

  static Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
