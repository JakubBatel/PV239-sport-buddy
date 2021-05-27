import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_buddy/bloc/auth_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/event_row.dart';
import 'package:sport_buddy/model/event/auth_event.dart';
import 'package:sport_buddy/model/state/auth_state.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/AuthService.dart';

class ProfileScreen extends StatelessWidget {
  final bool _logged;

  ProfileScreen(this._logged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _logged ? Text('My profile') : Text('User profile'),
          actions: [
            if (_logged)
              IconButton(
                  icon: Icon(Icons.logout), onPressed: () => _signOut(context))
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is NotAuthenticated) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: [
                _logged ? _buildUserInfo(context) : _buildProfileInfo(context),
                SizedBox(height: 20),
                _buildPastEvents(context),
              ],
            ),
          ),
        ));
  }

  Widget _buildProfileInfo(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel>(builder: (context, user) {
      return Column(
        children: [
          _buildPicture(user.profilePicture),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(user.name,
                      style: Theme.of(context).textTheme.headline3),
                ),
              ),
            ],
          )
        ],
      );
    });
  }

  Widget _buildUserInfo(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    double _width = MediaQuery.of(context).size.width;

    return BlocBuilder<UserCubit, UserModel>(
      builder: (context, model) => Column(
        children: [
          _buildPicture(model.profilePicture),
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () => _changePhoto(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: userCubit.editUser
                      ? Container(
                          width: _width * 0.60,
                          child: TextFormField(
                            initialValue: model.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                            onChanged: (text) => userCubit.updateUserName(text),
                          ),
                        )
                      : Text(model.name,
                          style: Theme.of(context).textTheme.headline3),
                ),
              ),
              userCubit.editUser
                  ? IconButton(
                      icon: Icon(Icons.done_outlined),
                      onPressed: () => {userCubit.changeEdit()})
                  : IconButton(
                      icon: Icon(Icons.mode_edit),
                      onPressed: () => {userCubit.changeEdit()}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPicture(String profilePicture) {
    return Container(
      height: 250,
      child: profilePicture == '' || profilePicture == null
          ? CircleAvatar(
              radius: 150.0,
              child: Icon(Icons.perm_identity_outlined, size: 100),
            )
          : CircleAvatar(
              radius: 150.0,
              backgroundImage: NetworkImage(profilePicture),
            ),
    );
  }

  Widget _buildPastEvents(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Past Events:",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      FutureBuilder(
        future: userCubit.state.events,
        builder: (context, eventsSnapshot) {
          if (eventsSnapshot.hasError) {
            return Text(eventsSnapshot.error.toString());
          }
          if (!eventsSnapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Column(
            children: eventsSnapshot.data
                .where((event) => DateTime.now().isAfter(event.time))
                .map<Widget>(
                  (event) => EventRow(event),
                )
                .toList(),
          );
        },
      ),
    ]);
  }

  void _signOut(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    AuthService.signOut();
    authBloc.add(UserLoggedOut());
  }

  Future<void> _changePhoto(BuildContext context) async {
    final userCubit = context.read<UserCubit>();
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user/profile/${userCubit.state.id}');

    var uploadTask = storageRef.putFile(File(pickedFile.path));
    var url = await storageRef.getDownloadURL();
    uploadTask.whenComplete(() => userCubit.updatePicturePath(url));
  }
}
