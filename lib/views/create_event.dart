import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/activity_dropdown.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/model/event_detail_model.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/screens/event_detail.dart';
import 'package:sport_buddy/services/event_service.dart';
import 'package:intl/intl.dart';
import 'package:sport_buddy/utils/activity_utils.dart';
import 'package:sport_buddy/utils/alert_dialog.dart';

class CreateEvent extends StatelessWidget {
  final bool editMode;

  CreateEvent(this.editMode);

  @override
  Widget build(BuildContext context) {
    final eventCubit = context.read<EventCubit>();
    if (!editMode) {
      eventCubit.setToCurrentLocation();
    }

    return Scaffold(
      appBar: AppBar(
        title: editMode ? Text('Edit Event') : Text('New Event'),
      ),
      bottomNavigationBar: _buildBottomButton(context),
      body: BlocBuilder<EventCubit, EventDetailModel>(
          builder: (context, model) => Center(
                child: ListView(
                  padding: EdgeInsets.all(20.0),
                  children: [
                    _buildEventDetail(context, model.event),
                    _buildParticipants(context, model.event),
                    _buildEventDescription(context, model.event),
                  ],
                ),
              )),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
        child: GradientButton(
          onPressed: () => saveEvent(context),
          child: Text(
            editMode ? 'Save changes' : 'Create event',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      elevation: 0,
    );
  }

  void saveEvent(BuildContext context) async {
    final userCubit = context.read<UserCubit>();
    final eventCubit = context.read<EventCubit>();

    if (_isFormFilledEnough(context)) {
      if (editMode) {
        EventService.updateEvent(eventCubit.state.event);
        Navigator.pop(context);
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<EventCubit>(
              create: (context) =>
                  EventCubit.fromEventModel(eventCubit.state.event),
              child: EventDetail(),
            ),
          ),
        );
      } else {
        eventCubit.updateOwner(userCubit.state);
        EventService.addEvent(eventCubit.state.event).then((event) {
          eventCubit.setEvent(event);
          eventCubit.setId(event.id);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<EventCubit>(
                create: (context) =>
                    EventCubit.fromEventModel(eventCubit.state.event),
                child: EventDetail(),
              ),
            ),
          );
        });
      }
    } else {
      showErrorDialog(context, 'Name cannot be empty!');
    }
  }

  bool _isFormFilledEnough(BuildContext context) {
    final eventCubit = context.read<EventCubit>();
    return eventCubit.state.event.name != '';
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
    final eventCubit = context.read<EventCubit>();
    double width = MediaQuery.of(context).size.width;
    final controller = TextEditingController(text: model.name);
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));

    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: ActivityDropdown(getActivityName(model.activity)),
          ),
          Container(
            width: (width - 105) * 0.80,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Event Name',
              ),
              controller: controller,
              style: Theme.of(context).textTheme.headline5,
              onChanged: (text) => eventCubit.updateName(text),
            ),
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
          Text(model.location.latitude.toString(),
              style: Theme.of(context).textTheme.headline6),
          Text(model.location.longitude.toString(),
              style: Theme.of(context).textTheme.headline6),
        ])
      ],
    );
  }

  Widget _buildEventDate(BuildContext context, EventModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Icon(Icons.calendar_today, size: 40),
        ),
        MaterialButton(
          onPressed: () => _selectDate(context),
          shape: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
          child: Text("${model.time.toLocal()}".split(' ')[0],
              style: Theme.of(context).textTheme.headline6),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final eventCubit = context.read<EventCubit>();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null) eventCubit.updateDate(picked);
  }

  Widget _buildEventTime(BuildContext context, EventModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Icon(
            Icons.access_time,
            size: 40,
          ),
        ),
        MaterialButton(
          onPressed: () => _selectTime(context),
          shape: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
          child: Text(DateFormat('kk:mm').format((model.time)),
              style: Theme.of(context).textTheme.headline6),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final eventCubit = context.read<EventCubit>();
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) eventCubit.updateTime(picked);
  }

  Widget _buildParticipants(BuildContext context, EventModel model) {
    final eventCubit = context.read<EventCubit>();
    final event = eventCubit.state.event;

    return Container(
      height: 100,
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, right: 5),
              child: Icon(Icons.people, size: 40),
            ),
            _buildParticipantsSlider(context),
            Text(
                event.unlimitedParticipants
                    ? ''
                    : event.maxParticipants.toString(),
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 100.0, right: 90),
            child:
                Text('Unlimited', style: Theme.of(context).textTheme.headline6),
          ),
          Switch(
            value: event.unlimitedParticipants,
            onChanged: (newVal) {
              eventCubit.updateUnlimitedParticipants(newVal);
            },
          )
        ]),
      ]),
    );
  }

  Widget _buildParticipantsSlider(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    final eventCubit = context.read<EventCubit>();
    final event = eventCubit.state.event;

    return Container(
      width: _width * 0.6,
      child: Slider(
        activeColor: event.unlimitedParticipants
            ? Colors.grey
            : Theme.of(context).primaryColor,
        inactiveColor:
            event.unlimitedParticipants ? Colors.grey : Color(0xffef8585),
        value: event.maxParticipants.toDouble(),
        min: 2,
        max: 30,
        label: event.maxParticipants.toString(),
        onChanged: (double value) {
          eventCubit.updateMaxParticipants(value);
        },
      ),
    );
  }

  Widget _buildEventDescription(BuildContext context, EventModel model) {
    final eventCubit = context.read<EventCubit>();
    final controller = TextEditingController(text: model.description);
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));

    double width = MediaQuery.of(context).size.width;
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
          child: Container(
            width: width * 0.85,
            height: 100,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              controller: controller,
              onChanged: (text) => eventCubit.updateDescription(text),
            ),
          ),
        ),
      ],
    );
  }
}
