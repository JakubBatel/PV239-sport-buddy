import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/bloc/auth_bloc.dart';
import 'package:sport_buddy/model/event/auth_event.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/AuthService.dart';
import 'package:sport_buddy/services/DatabaseService.dart';
import 'package:sport_buddy/utils/activity_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';

import 'event_detail.dart';

class ProfileScreen extends StatelessWidget {
  final bool _logged;
  final UserModel userModel;

  ProfileScreen(this._logged, this.userModel);

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
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            _logged ? _buildUserInfo(context) : _buildProfileInfo(context),
            SizedBox(height: 20),
            _buildPastEvents(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Column(
      children: [
        _buildPicture(userModel.profilePicture),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(userModel.name,
                    style: Theme.of(context).textTheme.headline3),
              ),
            ),
          ],
        )
      ],
    );
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
      child: profilePicture == ''
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

    final userId = _logged ? userCubit.state.userID : userModel.userID;


    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child:
            Text("Past Events:", style: Theme.of(context).textTheme.headline4),
      ),
      StreamBuilder<QuerySnapshot>(
          stream: DatabaseService().getPastParticipatedEvents(userId),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data == null) return CircularProgressIndicator();

            return Column(
                children: snapshot.data.docs
                    .map(
                      (DocumentSnapshot doc) => Container(
                        height: 60,
                        child: _buildEventRow(context, doc),
                      ),
                    )
                    .toList());
          }),
    ]);
  }

  Widget _buildEventRow(BuildContext context, DocumentSnapshot doc) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<EventCubit>(
              create: (context) =>
                  EventCubit.fromEventModel(getEventFromDocument(doc)),
              child: EventDetail(),
            ),
          ),
        );
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ActivityIcon(
              activity: getActivityFromString(doc.data()['activity']),
              size: 50,
            ),
          ),
          Text(doc.data()['name'])
        ],
      ),
    );
  }

    
  void _signOut(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final authService = AuthService();
    authService.signOut();
    authBloc.add(UserLoggedOut());
    Navigator.pop(context);
  }

  Future<void> _changePhoto(BuildContext context) async {
    final userCubit = context.read<UserCubit>();
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("user/profile/${userCubit.getUserID()}");

    var uploadTask = storageRef.putFile(File(pickedFile.path));
    uploadTask.whenComplete(() => userCubit.setPicture());
  }
}
