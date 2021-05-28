import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/activity_icon.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/components/gradient_label.dart';
import 'package:sport_buddy/components/profile_circle_avatar.dart';
import 'package:sport_buddy/model/event_detail_model.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/screens/profile_screen.dart';
import 'package:sport_buddy/services/event_service.dart';
import 'package:sport_buddy/utils/alert_dialog.dart';
import 'package:sport_buddy/views/create_event.dart';

class EventDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventDetailModel>(
      builder: (context, model) => Scaffold(
        appBar: AppBar(
          title: Text('Event Detail'),
          actions: (_canEdit(context, model)) ? [_editEvent(context)] : [],
        ),
        bottomNavigationBar: (model.event.isPast)
            ? null
            : _buildBottomNavigationBar(context, model),
        body: Center(
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              _buildEventDetail(context, model),
              _buildEventDescription(context, model.event),
              SizedBox(height: 20),
              _buildEventParticipants(context, model),
            ],
          ),
        ),
      ),
    );
  }

  bool _canEdit(BuildContext context, EventDetailModel model) {
    final currentUser = context.read<UserCubit>().state;
    return !model.event.isPast && model.event.owner == currentUser;
  }

  Widget _editEvent(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.mode_edit,
        color: Colors.white,
      ),
      onPressed: () {
        _openEditEvent(context);
      },
    );
  }

  void _openEditEvent(BuildContext context) async {
    final eventCubit = context.read<EventCubit>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<EventCubit>(
          create: (context) =>
              EventCubit.fromEventModel(eventCubit.state.event),
          child: CreateEvent(true),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, EventDetailModel model) {
    return BottomAppBar(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
        child: _buildBottomButton(
          context,
          model,
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    EventDetailModel model,
  ) {
    final currentUser = context.read<UserCubit>().state;

    if (model.event.owner == currentUser) {
      return _buildDeleteButton(context, model.event);
    }

    if (model.pendingParticipants.contains(currentUser)) {
      return _buildPendingButton();
    }

    if (model.participants.contains(currentUser)) {
      return _buildLeaveButton(context, model.event, currentUser);
    }

    return _buildJoinButton(context, model.event, currentUser);
  }

  Widget _buildDeleteButton(BuildContext context, EventModel event) {
    return GradientButton(
      onPressed: () {
        _deleteEvent(context, event.id);
      },
      child: Text(
        'Cancel event',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _deleteEvent(BuildContext context, eventId) {
    showAlertDialog(context, () {
      EventService.deleteEvent(eventId);
      Navigator.pop(context);
      showSnackbar(context, 'Event deleted');
    }, 'Are sure you want to completely delete this event?');
  }

  Widget _buildPendingButton() {
    return MaterialButton(
      onPressed: null,
      child: Text(
        'pending',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildLeaveButton(
    BuildContext context,
    EventModel event,
    UserModel currentUser,
  ) {
    final eventCubit = context.read<EventCubit>();
    return GradientButton(
      onPressed: () => eventCubit.removeParticipant(currentUser),
      child: Text(
        'Leave event',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildJoinButton(
    BuildContext context,
    EventModel event,
    UserModel currentUser,
  ) {
    final eventCubit = context.read<EventCubit>();
    return GradientButton(
      onPressed: () => eventCubit.addPendingParticipant(currentUser),
      child: Text(
        'Join event',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildEventDetail(BuildContext context, EventDetailModel model) {
    return Container(
        height: 350,
        child: Column(
          children: [
            _buildEventName(context, model.event),
            _buildEventLocation(context, model.event),
            SizedBox(height: 30),
            _buildEventDate(context, model.event),
            SizedBox(height: 30),
            _buildEventTime(context, model.event),
          ],
        ));
  }

  Widget _buildEventName(BuildContext context, EventModel event) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 20),
            child: ActivityIcon(
              activity: event.activity,
              size: 70,
            ),
          ),
          Text(
            event.name,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }

  Widget _buildEventLocation(BuildContext context, EventModel event) {
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
          Text(
            event.location.latitude.toString(),
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            event.location.longitude.toString(),
            style: Theme.of(context).textTheme.headline6,
          ),
        ])
      ],
    );
  }

  Widget _buildEventDate(BuildContext context, EventModel event) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 40),
          child: Icon(Icons.calendar_today, size: 40),
        ),
        Text(
          DateFormat('dd. MM. yyyy').format(event.time).toString(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  Widget _buildEventTime(BuildContext context, EventModel event) {
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
        Text(DateFormat('kk:mm').format(event.time).toString(),
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  Widget _buildEventDescription(BuildContext context, EventModel event) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Description:',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(event.description),
        ),
      ],
    );
  }

  Widget _buildEventParticipants(BuildContext context, EventDetailModel model) {
    final currentUser = context.read<UserCubit>().state;
    return Column(
      children: [
        _buildParticipantHeadline(
          context,
          model,
        ),
        SizedBox(height: 20),
        Column(
          children: model.participants
              .map<Widget>(
                (participant) => _buildParticipantRow(
                  context,
                  model.event,
                  participant,
                  currentUser,
                ),
              )
              .toList(),
        ),
        if (currentUser == model.event.owner)
          Column(
            children: model.pendingParticipants
                .map<Widget>(
                  (participant) => _buildParticipantRow(
                    context,
                    model.event,
                    participant,
                    currentUser,
                    pending: true,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildParticipantHeadline(
      BuildContext context, EventDetailModel model) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Participants:',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              '${model.participants.length}/${model.event.unlimitedParticipants ? '-' : model.event.maxParticipants}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantRow(
    BuildContext context,
    EventModel event,
    UserModel participant,
    UserModel currentUser, {
    bool pending = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<String>(
            future: getParticipantPicture(participant.id),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return GestureDetector(
                onTap: () {
                  _showProfile(context, participant);
                },
                child: Row(
                  children: [
                    ProfileCircleAvatar(
                      pictureUrl: snapshot.data,
                      radius: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        participant.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (pending)
                  ? (event.isPast)
                      ? Container()
                      : _buildAcceptDeclineButtons(
                          context,
                          event,
                          participant,
                          currentUser,
                        )
                  : _buildLabelOrRemoveButton(
                      context,
                      event,
                      participant,
                      currentUser,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context, UserModel participant) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(model: participant),
      ),
    );
  }

  Widget _buildLabelOrRemoveButton(
    BuildContext context,
    EventModel event,
    UserModel participant,
    UserModel currentUser,
  ) {
    final eventCubit = context.read<EventCubit>();
    if (!event.isPast &&
        currentUser == event.owner &&
        participant != currentUser) {
      return _buildConfirmationButton(() {
        showAlertDialog(context, () {
          eventCubit.removeParticipant(participant);
        }, 'Are sure you want to delete this user from the event?');
      });
    }

    final label = _getLabelText(event, participant, currentUser);

    if (label == '') {
      return Container();
    }
    return Container(
      height: 25,
      child: GradientLabel(
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  String _getLabelText(
    EventModel event,
    UserModel participant,
    UserModel currentUser,
  ) {
    if (participant == currentUser) {
      return 'You';
    }
    if (participant == event.owner) {
      return 'Organizer';
    }
    return '';
  }

  Widget _buildAcceptDeclineButtons(
    BuildContext context,
    EventModel event,
    UserModel participant,
    UserModel currentUser,
  ) {
    if (currentUser != event.owner) {
      return Row();
    }

    final eventCubit = context.read<EventCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildConfirmationButton(() {
          showAlertDialog(context, () {
            eventCubit.moveToParticipants(participant);
          }, 'Are sure you want to add this user to the event?');
        }, disallow: false),
        _buildConfirmationButton(() {
          showAlertDialog(context, () {
            eventCubit.removePendingParticipant(participant);
          }, 'Are sure you want to delete this user request?');
        })
      ],
    );
  }

  Future<String> getParticipantPicture(String participantId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    var downloadUrl = '';
    final storageRef = storage.ref().child('user/profile/$participantId');
    try {
      downloadUrl = await storageRef.getDownloadURL();
    } catch (e) {
      print('User do not have any picture');
    }
    return downloadUrl;
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
