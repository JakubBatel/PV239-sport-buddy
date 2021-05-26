import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/screens/profile_screen.dart';
import 'package:sport_buddy/services/DatabaseService.dart';
import 'package:intl/intl.dart';
import 'package:sport_buddy/utils/alert_dialog.dart';
import 'package:sport_buddy/views/create_event.dart';

class EventDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventModel>(
      builder: (context, model) => Scaffold(
        appBar: AppBar(
          title: Text('Event Detail'),
          actions: [_editEvent(context)],
        ),
        bottomNavigationBar: _buildBottomButton(context, model),
        body: Center(
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              _buildEventDetail(context, model),
              _buildEventDescription(context, model),
              SizedBox(height: 20),
              _buildEventParticipants(context, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editEvent(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.mode_edit,
        color: Colors.white,
      ),
      onPressed: () {
        _openEditEvent(context);
      }, // TODO add action
    );
  }

  void _openEditEvent(BuildContext context) async {
    final eventCubit = context.read<EventCubit>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<EventCubit>(
          create: (context) => EventCubit.fromEventModel(eventCubit.state),
          child: CreateEvent(true),
        ),
      ),
    );
  }

  bool _isOwner(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final eventCubit = context.read<EventCubit>();
    return userCubit.state.userID == eventCubit.state.owner;
  }

  bool _participate(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final eventCubit = context.read<EventCubit>();
    return eventCubit.state.participants.contains(userCubit.state.userID);
  }

  bool _requestPending(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final eventCubit = context.read<EventCubit>();
    return eventCubit.state.pendingParticipants
        .contains(userCubit.state.userID);
  }

  bool _isPastEvent(BuildContext context) {
    final eventCubit = context.read<EventCubit>();
    return eventCubit.state.time.isBefore(DateTime.now());
  }

  Widget _buildBottomButton(BuildContext context, model) {
    return BottomAppBar(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
        child: getBottomButton(context, model),
      ),
      elevation: 0,
    );
  }

  Widget getBottomButton(BuildContext context, EventModel model) {
    final userCubit = context.read<UserCubit>();
    final databaseService = DatabaseService();

    if (_isPastEvent(context)) {
      return MaterialButton(
        color: Colors.black12,
        onPressed: () {},
        child: Text(
          'Event already ended',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (_isOwner(context)) {
      return GradientButton(
        onPressed: () {
          showAlertDialog(context, () {
            databaseService.deleteEvent(model.id);
          }, "Are sure you want to completely delete this event?");
          // TODO: if yes, return to map screen and show some alert that it was deleted
        },
        child: Text(
          'Cancel event',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (_requestPending(context)) {
      return MaterialButton(
        color: Colors.black12,
        onPressed: () {},
        child: Text(
          'pending',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return GradientButton(
      onPressed: () => _participate(context)
          ? databaseService.deleteParticipant(userCubit.state.userID, model.id)
          : databaseService.addParticipantToPending(
              userCubit.state.userID, model.id),
      child: Text(
        _participate(context) ? 'Leave event' : 'Join event',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildEventDetail(BuildContext context, EventModel model) {
    return Container(
        height: 350,
        child: Column(
          children: [
            _buildEventName(context, model),
            _buildEventLocation(context, model),
            SizedBox(height: 30),
            _buildEventDate(context, model),
            SizedBox(height: 30),
            _buildEventTime(context, model),
          ],
        ));
  }

  Widget _buildEventName(BuildContext context, EventModel model) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 20),
            child: ActivityIcon(
              activity: model.activity,
              size: 70,
            ),
          ),
          Text(
            model.name,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }

  Widget _buildEventLocation(BuildContext context, EventModel model) {
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

  Widget _buildEventDate(BuildContext context, EventModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 40),
          child: Icon(Icons.calendar_today, size: 40),
        ),
        Text(DateFormat('dd. MM. yyyy').format(model.time).toString(),
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  Widget _buildEventTime(BuildContext context, EventModel model) {
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
        Text(DateFormat('kk:mm').format(model.time).toString(),
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  Widget _buildEventDescription(BuildContext context, EventModel model) {
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
          child: Text(model.description),
        ),
      ],
    );
  }

  Widget _buildEventParticipants(BuildContext context, EventModel model) {
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
                  '${model.participants.length}/${model.unlimitedParticipants ?  '-' : model.maxParticipants}',
                  style: Theme.of(context).textTheme.headline4),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      Column(
        children: model.participants
            .map<Widget>(
                (participantId) => getParticipantRowByUserRef(participantId))
            .toList(),
      ),
      if (_isOwner(context))
        Column(
          children: model.pendingParticipants
              .map<Widget>((participantId) =>
                  getParticipantRowByUserRef(participantId, pending: true))
              .toList(),
        ),
    ]);
  }

  Widget getParticipantRowByUserRef(String participantId, {pending: false}) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(participantId);
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
          return _buildParticipantRow(context, snapshotFuture.data, pending);
        }

        return Text('loading');
      },
    );
  }

  Widget _buildParticipantRow(
      BuildContext context, DocumentSnapshot data, pending) {
    String name = data.data()['name'];

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<String>(
              future: getParticipantPicture(data.id),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) return CircularProgressIndicator();
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(false, UserModel(name, snapshot.data, data.id)),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      snapshot.data == ''
                          ? CircleAvatar(
                              radius: 25.0,
                              child:
                                  Icon(Icons.perm_identity_outlined, size: 25),
                            )
                          : CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(snapshot.data),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(name,
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ],
                  ),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...chooseButtons(context, data.id, pending),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> getParticipantPicture(String participantId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    var downloadUrl = '';
    final storageRef = storage.ref().child("user/profile/$participantId");
    try {
      downloadUrl = await storageRef.getDownloadURL();
    } catch (e) {
      print("User do not have any picture");
    }
    return downloadUrl;
  }

  List<Widget> chooseButtons(
      BuildContext context, String participantId, pending) {
    final userCubit = context.read<UserCubit>();
    final eventCubit = context.read<EventCubit>();
    String sign = '';
    if (participantId == userCubit.state.userID) {
      sign = 'You';
    }
    if (participantId == eventCubit.state.owner) {
      sign = 'Organizer';
    }

    if (pending && _isOwner(context) && !_isPastEvent(context)) {
      return [
        _buildConfirmationButton(() {
          showAlertDialog(context, () {
            eventCubit.addParticipant(participantId, eventCubit.state.id);
          }, "Are sure you want to add this user to the event?");
        }, disallow: false),
        _buildConfirmationButton(() {
          showAlertDialog(context, () {
            eventCubit.deletePendingParticipant(
                participantId, eventCubit.state.id);
          }, "Are sure you want to delete this user request?");
        })
      ];
    }

    if (sign == '' && _isOwner(context) && !_isPastEvent(context)) {
      return [
        _buildConfirmationButton(() {
          showAlertDialog(context, () {
            eventCubit.deleteParticipant(participantId, eventCubit.state.id);
          }, "Are sure you want to delete this user from the event?");
        })
      ];
    }

    if (sign != '') {
      return [
        Container(
          height: 25,
          child: GradientButton(
            child: Text(
              sign,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ];
    }

    return [];
  }

  Widget _buildConfirmationButton(Function action, {bool disallow = true}) {
    return Container(
      width: 50,
      child: RawMaterialButton(
        onPressed: action,
        elevation: 2.0,
        fillColor: disallow ? Colors.red : Colors.green,
        child: Icon(
          disallow ? Icons.delete_forever_rounded : Icons.done_outline,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(5.0),
        shape: CircleBorder(),
      ),
    );
  }
}
