import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/screens/main_screen.dart';
import 'package:sport_buddy/views/login.dart';
import 'components/event_row.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';


class ProfilPage extends StatelessWidget {


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
            _buildPastEvents(context)
          ],
        )));
  }

  Widget _buildUserInfo(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserModel>(
      builder: (context, model) =>Column(
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
                    backgroundImage: NetworkImage(userCubit.state.profilePicture),
                  ),
            ),
          IconButton(
              icon: Icon(Icons.add_a_photo), onPressed: () => _changePhoto(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: userCubit.editUser ?
                      Container(
                        width: 300,
                        child:
                        TextFormField(
                            initialValue: model.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4,
                            onChanged: (text) =>
                            userCubit.updateUserName(text))) :
                    Text(model.name,
                        style: Theme.of(context).textTheme.headline4)
                    ),
                  ),
              userCubit.editUser ?
              IconButton(icon: Icon(Icons.done_outlined), onPressed: () => {
                userCubit.changeEdit()}) :
              IconButton(icon: Icon(Icons.mode_edit), onPressed: () => {
                  userCubit.changeEdit()
              }),
            ],
          )
        ],
    )
    );
  }

  Widget _buildPastEvents(BuildContext context) {
    //TODO: real events
    EventModel e = EventModel('Fotbal na Svoboďáku', 'desc', Activity.football,
        LocationModel(1, 22), DateTime.now(), UserModel('Joe', "", ""), 6, []);
    EventModel e2 = EventModel('StreetWorkout', 'desc', Activity.workout,
        LocationModel(1, 22), DateTime.now(), UserModel('Joe', "", ''), 6, []);
    EventModel e3 = EventModel('Čunča', 'desc', Activity.basketball,
        LocationModel(1, 22), DateTime.now(), UserModel('Joe', "", ''), 6, []);
    final List<EventModel> eventsMock = [e, e2, e3, e2, e2, e3, e2, e, e];

    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text("Past Events:",
              style: Theme.of(context).textTheme.headline6)),
      Column(
        children: [...(eventsMock.map((event) => EventRow(event)).toList())],
      ),
    ]);
  }

  void _openLogin(BuildContext context) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => BlocProvider.value(
                  value: BlocProvider.of<UserCubit>(context),
                  child: Login())));
  }
}

  Future<void> _changePhoto(BuildContext context) async {
      final userCubit = context.read<UserCubit>();
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      final storageRef = FirebaseStorage.instance.ref().child("user/profile/${userCubit.getUserID()}");

      var uploadTask = storageRef.putFile(File(pickedFile.path));
      uploadTask.whenComplete(() => userCubit.setPicture());
  }
