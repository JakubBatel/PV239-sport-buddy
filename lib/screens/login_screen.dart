import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sport_buddy/bloc/auth_bloc.dart';
import 'package:sport_buddy/bloc/login_bloc.dart';
import 'package:sport_buddy/components/email_password_form.dart';
import 'package:sport_buddy/components/loading.dart';
import 'package:sport_buddy/model/event/login_event.dart';
import 'package:sport_buddy/model/state/auth_state.dart';
import 'package:sport_buddy/model/state/login_state.dart';
import 'package:sport_buddy/screens/register_screen.dart';
import 'package:sport_buddy/services/auth_service.dart';
import 'package:sport_buddy/utils/alert_dialog.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  return showSnackbar(context, "Login error");
                }
              },
              child: _buildLoginForm(context)),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) =>
              (state is LoginLoading) ? Loading() : _buildLoginContent(context),
        ),
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/logo.png'),
          height: 100.0,
        ),
        SizedBox(height: 16),
        SignInButton(
          Buttons.Google,
          text: "Sign up with Google",
          onPressed: () {
            final loginBloc = BlocProvider.of<LoginBloc>(context);
            loginBloc.add(LoginWithGoogleButtonPressed());
          },
        ),
        SignInButton(
          Buttons.Facebook,
          text: "Sign up with Facebook",
          onPressed: () {
            final loginBloc = BlocProvider.of<LoginBloc>(context);
            loginBloc.add(LoginWithFacebookButtonPressed());
          },
        ),
        SizedBox(height: 8),
        Text("OR"),
        SizedBox(height: 8),
        EmailPasswordForm(
            buttonText: "Login",
            clickAction: (email, password) {
              final loginBloc = BlocProvider.of<LoginBloc>(context);

              loginBloc.add(LoginInWithEmailButtonPressed(
                  email: email, password: password));
            }),
        SizedBox(height: 8.0),
        MaterialButton(
            child: Text(
              "Create account",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => {_openRegister(context)}),
      ],
    );
  }

  void _openRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }
}
