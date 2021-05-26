import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/login_bloc.dart';
import 'package:sport_buddy/components/loading.dart';
import 'package:sport_buddy/model/state/login_state.dart';

import 'gradient_button.dart';

class EmailPasswordForm extends StatefulWidget {
  Function clickAction;
  String buttonText;

  EmailPasswordForm({Key key, @required this.buttonText, @required this.clickAction}) : super(key: key);

  @override
  EmailPasswordFormState createState() => EmailPasswordFormState();
}

class EmailPasswordFormState extends State<EmailPasswordForm> {
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
            return Loading();
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
          height: 8,
        ),
        _buildPasswordInput(context),
        const SizedBox(
          height: 16,
        ),
        GradientButton(
          onPressed: () {
            state is LoginLoading
                ? {}
                : widget.clickAction(
                _emailController.text, _passwordController.text);
          },
          child: Text(
            widget.buttonText,
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
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/ic_account.png')),
                  Expanded(
                    child: TextFormField(
                        cursorHeight: 16.0,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
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
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/ic_account.png')),
                  Expanded(
                    child: TextFormField(
                        cursorHeight: 16.0,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            labelText: 'Password',
                            filled: true,
                            isDense: true
                        ),
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
}