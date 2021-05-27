import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/auth_bloc.dart';
import 'package:sport_buddy/bloc/login_bloc.dart';
import 'package:sport_buddy/components/email_password_form.dart';
import 'package:sport_buddy/components/loading.dart';
import 'package:sport_buddy/model/event/auth_event.dart';
import 'package:sport_buddy/model/event/login_event.dart';
import 'package:sport_buddy/model/state/auth_state.dart';
import 'package:sport_buddy/model/state/login_state.dart';
import 'package:sport_buddy/services/AuthService.dart';
import 'package:sport_buddy/utils/alert_dialog.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: SafeArea(
                minimum: const EdgeInsets.all(16),
                child: Center(child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Loading();
                    }
                    return _buildRegisterForm(context);
                  },
                )))));
  }

  Widget _buildRegisterForm(BuildContext context) {
    final authService = AuthService();
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Container(
        alignment: Alignment.center,
        child: BlocProvider<LoginBloc>(
            create: (context) =>
                LoginBloc(authBloc, authService),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                   Navigator.pop(context);
                }

                if (state is LoginFailure) {
                  showSnackbar(context, "error");
                }
              },
            child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return Loading();
                  }

                  return _buildRegisterContent(context);
                }
            )
        ))
    );
  }

  Widget _buildRegisterContent(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Register",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 32.0),
          EmailPasswordForm(
              buttonText: "Register",
              clickAction: (email, password) {
                final loginBloc = BlocProvider.of<LoginBloc>(context);

                loginBloc.add(
                    RegisterWithEmailButtonPressed(
                        email: email, password: password)
                );
              }),
          SizedBox(height: 8.0),
          MaterialButton(
              child: Text(
                "Already have a account",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => {Navigator.pop(context)}),
        ]);
  }
}
