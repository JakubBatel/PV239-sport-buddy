import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/activity_dropdown.dart';
import 'package:sport_buddy/components/gradient_button.dart';
import 'package:sport_buddy/model/event_model.dart';
import 'package:sport_buddy/services/DatabaseService.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Detail'),
      ),
      bottomNavigationBar: _buildBottomButton(context),
      body: BlocBuilder<EventCubit, EventModel>(
          builder: (context, model) => Center(
                child: ListView(
                  padding: EdgeInsets.all(20.0),
                  children: [
                    _buildEventDetail(context, model),
                    _buildParticipants(context, model),
                    _buildEventDescription(context, model),
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
          onPressed: () => createNewEvent(context),
          child: Text(
            'Create event',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      elevation: 0,
    );
  }

  void createNewEvent(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final eventCubit = context.read<EventCubit>();
    final databaseService = DatabaseService(userCubit.state.userID);
    databaseService.addEvent(eventCubit.state);
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

    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ActivityDropdown(),
          Container(
            width: (width - 105) * 0.80,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Event Name',
              ),
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
    double _width = MediaQuery.of(context).size.width;
    final eventCubit = context.read<EventCubit>();
    return Container(
      height: 100,
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: Icon(Icons.people, size: 40),
            ),
            Container(
              width: _width * 0.6,
              child: Slider(
                activeColor: eventCubit.state.unlimitedParticipants
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
                inactiveColor: eventCubit.state.unlimitedParticipants
                    ? Colors.grey
                    : Color(0xffef8585),
                value: eventCubit.state.maxParticipants.toDouble(),
                min: 0,
                max: 30,
                label: eventCubit.state.maxParticipants.toString(),
                onChanged: (double value) {
                  eventCubit.updateMaxParticipants(value);
                },
              ),
            ),
            Text(
                eventCubit.state.unlimitedParticipants
                    ? ''
                    : eventCubit.state.maxParticipants.toString(),
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 100.0, right: 25),
            child: Text('Unlimited participants',
                style: Theme.of(context).textTheme.headline6),
          ),
          Switch(
            value: eventCubit.state.unlimitedParticipants,
            onChanged: (newVal) {
              eventCubit.updateUnlimitedParticipants(newVal);
            },
          )
        ]),
      ]),
    );
  }

  Widget _buildEventDescription(BuildContext context, EventModel model) {
    final eventCubit = context.read<EventCubit>();
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
              onChanged: (text) => eventCubit.updateDescription(text),
            ),
          ),
        ),
      ],
    );
  }
}
