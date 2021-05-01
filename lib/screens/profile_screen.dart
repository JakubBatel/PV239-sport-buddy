import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/services/DatabaseService.dart';
import 'package:sport_buddy/screens/login_screen.dart';
import 'package:sport_buddy/utils/activity_utils.dart';
import '../components/event_row.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Scaffold(
        appBar: AppBar(
          title: Text('My profile'),
          actions: [
            IconButton(
                icon: Icon(Icons.logout), onPressed: () => _openLogin(context))
          ],
        ),
        body: Center(
            child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            _buildUserInfo(context),
            SizedBox(height: 20),
            _buildPastEvents(context),
          ],
        )));
  }

  Widget _buildUserInfo(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserModel>(
        builder: (context, model) => Column(
              children: [
                Container(
                  height: 250,
                  child: model.profilePicture == ''
                      ? CircleAvatar(
                          radius: 150.0,
                          child: Icon(Icons.add_photo_alternate_outlined),
                        )
                      : CircleAvatar(
                          radius: 150.0,
                          backgroundImage:
                              NetworkImage(userCubit.state.profilePicture),
                        ),
                ),
                IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () => _changePhoto(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                          padding: EdgeInsets.only(left: 40),
                          // TODO: fix textformfield overflow on smaller display
                          child: userCubit.editUser
                              ? Container(
                                  width: 300,
                                  child: TextFormField(
                                      initialValue: model.name,
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      onChanged: (text) =>
                                          userCubit.updateUserName(text)))
                              : Text(model.name,
                                  style:
                                      Theme.of(context).textTheme.headline4)),
                    ),
                    userCubit.editUser
                        ? IconButton(
                            icon: Icon(Icons.done_outlined),
                            onPressed: () => {userCubit.changeEdit()})
                        : IconButton(
                            icon: Icon(Icons.mode_edit),
                            onPressed: () => {userCubit.changeEdit()}),
                  ],
                )
              ],
            ));
  }

  Widget _buildPastEvents(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text("Past Events:",
              style: Theme.of(context).textTheme.headline6)),
      StreamBuilder<QuerySnapshot>(
          stream: DatabaseService(userCubit.state.userID)
              .getPastParticipatedEvents(),
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
                      (DocumentSnapshot doc) => EventRow(
                        EventModel(
                          name: doc.data()['name'],
                          description: doc.data()['description'],
                          activity:
                              getActivityFromString(doc.data()['activity']),
                          time: doc.data()['time'],
                          owner: (doc.data()['owner']).toString(),
                          maxParticipants: doc.data()['maxParticipants'],
                          participants: (List.from(doc.data()['participants']))
                              .map((e) => e.toString())
                              .toList(),
                        ),
                      ),
                    )
                    .toList());
          }),
    ]);
  }

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => BlocProvider.value(
          value: BlocProvider.of<UserCubit>(context),
          child: LoginScreen(),
        ),
      ),
    );
  }
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
