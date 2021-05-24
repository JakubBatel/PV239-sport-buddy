import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/auth_bloc.dart';
import 'package:sport_buddy/bloc/login_bloc.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/model/event/auth_event.dart';
import 'package:sport_buddy/model/event/login_event.dart';
import 'package:sport_buddy/model/state/auth_state.dart';
import 'package:sport_buddy/model/state/login_state.dart';
import 'package:sport_buddy/screens/login_screen.dart';
import 'package:sport_buddy/services/AuthenticationService.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: SafeArea(
                minimum: const EdgeInsets.all(16),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is NotAuthenticated) {
                      return _buildRegisterForm(context);
                    }
                    if (state is AuthError) {
                      return _buildErrorState(context);
                    }

                    if (state is AuthLoading) {
                      return _buildLoading();
                    }

                    return Center();
                  },
                ))));
  }

  Widget _buildRegisterForm(BuildContext context) {
    final authService = AuthService();
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: EmailPasswordRegisterForm(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Text(state.message),
            MaterialButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Retry'),
              onPressed: () {
                authBloc.add(AppLoaded());
              },
            )
          ],
        ));
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
}

class EmailPasswordRegisterForm extends StatefulWidget {
  @override
  EmailPasswordRegisterFormState createState() => EmailPasswordRegisterFormState();
}

class EmailPasswordRegisterFormState extends State<EmailPasswordRegisterForm> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(child: _buildLoginForm(context, state));
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildEmailInput(context),
        SizedBox(
          height: 12,
        ),
        _buildPasswordInput(context),
        const SizedBox(
          height: 16,
        ),
        GradientButton(
          onPressed: () {
            state is LoginLoading ? {} : _loginClickAction(context);
          } ,
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  void _showError(String error) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }

  Widget _buildEmailInput(BuildContext context) {
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
                    child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          filled: true,
                          isDense: true,
                        ),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: _validateEmail),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
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
                    child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Password', filled: true, isDense: true),
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        autocorrect: false,
                        obscureText: true,
                        validator: _validatePasword),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  String _validateEmail(String email) {
    //TODO: email regex

    if (email == null) {
      return 'Email is required.';
    }
    return null;
  }

  String _validatePasword(String password) {
    if (password == null) {
      return 'Password is required.';
    }
    return null;
  }

  void _loginClickAction(BuildContext context) {
    // TODO: fix multiple clicks
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _loginBloc.add(RegisterWithEmailButtonPressed(
        email: _emailController.text, password: _passwordController.text));
    Navigator.pop(context);
  }
}