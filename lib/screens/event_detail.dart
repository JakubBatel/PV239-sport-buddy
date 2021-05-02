import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/services/DatabaseService.dart';
import 'package:intl/intl.dart';
import 'package:sport_buddy/utils/activity_utils.dart';

class EventDetail extends StatelessWidget {
  // TODO rewrite build method so it uses this model
  final EventModel event;

  EventDetail({this.event});

  @override
  Widget build(BuildContext context) {
    // TODO: get real event - load cubit when click on event in map???
    final eventId = '3EBttdcxjuRBI8BAWVQx';

    final userCubit = context.read<UserCubit>();
    var databaseService = DatabaseService(userCubit.state.userID);
    return StreamBuilder<DocumentSnapshot>(
        stream: databaseService.getEvent(eventId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data == null) return CircularProgressIndicator();

          return Scaffold(
            appBar: AppBar(
              title: Text('Event Detail'),
            ),
            bottomNavigationBar: _buildBottomButton(context, snapshot),
            body: Center(
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  _buildEventDetail(context, snapshot),
                  _buildEventDescription(context, snapshot),
                  SizedBox(height: 20),
                  _buildEventParticipants(context, snapshot),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBottomButton(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    final userCubit = context.read<UserCubit>();
    final databaseService = DatabaseService(userCubit.state.userID);
    final participate = snapshot.data
        .get('participants')
        .map((u) => u.id)
        .toList()
        .contains(userCubit.state.userID);
    return BottomAppBar(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
        child: GradientButton(
          onPressed: () => participate
              ? databaseService.deleteParticipant(
                  userCubit.state.userID, snapshot.data.id)
              : databaseService.addParticipant(
                  userCubit.state.userID, snapshot.data.id),
          child: Text(
            participate ? 'Leave event' : 'Join event',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildEventDetail(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Container(
        height: 350,
        child: Column(
          children: [
            _buildEventName(context, snapshot),
            _buildEventLocation(context, snapshot),
            SizedBox(height: 30),
            _buildEventDate(context, snapshot),
            SizedBox(height: 30),
            _buildEventTime(context, snapshot),
          ],
        ));
  }

  Widget _buildEventName(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 20),
            child: ActivityIcon(
              activity: getActivityFromString(snapshot.data.get('activity')),
              size: 70,
            ),
          ),
          Text(
            snapshot.data.get('name'),
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }

  Widget _buildEventLocation(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 40),
          child: Icon(
            Icons.location_on,
            size: 40,
          ),
        ),
        Column(children: [
          // TODO: add real location
          Text('74.7539459735', style: Theme.of(context).textTheme.headline6),
          Text('49.7539459735', style: Theme.of(context).textTheme.headline6),
        ])
      ],
    );
  }

  Widget _buildEventDate(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 40),
          child: Icon(Icons.calendar_today, size: 40),
        ),
        Text(
            DateFormat('dd. MM. yyyy').format(
                DateTime.parse(snapshot.data.get('time').toDate().toString())),
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  Widget _buildEventTime(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 40),
          child: Icon(
            Icons.access_time,
            size: 40,
          ),
        ),
        Text(
            DateFormat('kk:mm').format(
                DateTime.parse(snapshot.data.get('time').toDate().toString())),
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  Widget _buildEventDescription(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Description:',
                  style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(snapshot.data.get('description')),
        ),
      ],
    );
  }

  Widget _buildEventParticipants(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    final userCubit = context.read<UserCubit>();
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Participants:', style: Theme.of(context).textTheme.headline4),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                  '${snapshot.data.get('participants').length}/${snapshot.data.get('maxParticipants')}',
                  style: Theme.of(context).textTheme.headline4),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      Column(
        children: snapshot.data
            .get('participants')
            .map<Widget>((ref) => getNameByUserRef(
                ref, snapshot.data.get('owner'), userCubit.state.userID))
            .toList(),
      ),
    ]);
  }

  Widget getNameByUserRef(
      DocumentReference userRef, String ownerId, String userId) {
    Future<DocumentSnapshot> user = userRef.get();

    return FutureBuilder<DocumentSnapshot>(
      future: user,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshotFuture) {
        if (snapshotFuture.hasError) {
          return Text("Something went wrong");
        }

        if (snapshotFuture.hasData && !snapshotFuture.data.exists) {
          return Text("User does not exist");
        }

        if (snapshotFuture.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshotFuture.data.data();

          if (userRef.id == ownerId) {
            return _buildParticipantRow(context, data['name'], 'Organizer');
          } else if (userRef.id == userId) {
            return _buildParticipantRow(context, data['name'], 'You');
          }
          return _buildParticipantRow(context, data['name'], '');
        }
        return Text('loading');
      },
    );
  }

  Widget _buildParticipantRow(BuildContext context, String name, String sign) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.headline6),
          if (sign != '')
            GradientButton(
              child: Text(
                sign,
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
