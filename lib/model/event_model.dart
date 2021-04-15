import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/user_model.dart';
import 'package:sport_buddy/enum/acitivity_enum.dart';

class EventModel{
  final String _name;
  final String _description;
  final Activity _activity;
  final LocationModel _location;
  final DateTime _time;
  final UserModel _owner;
  final int _maxParticipants;
  final List<UserModel> _participants;



  EventModel(this._name,this._description, this._activity, this._location, this._time, this._owner, this._maxParticipants, this._participants);


  get activity => _activity;

  get name => _name;



}