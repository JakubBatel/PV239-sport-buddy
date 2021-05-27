import 'package:quiver/core.dart';

class LocationModel {

  final double latitude;
  final double longitude;

  @override
  bool operator==(Object other) => other is LocationModel && latitude == other.latitude && longitude == other.longitude;

  @override
  int get hashCode => hashObjects([latitude, longitude]);

  LocationModel({this.latitude, this.longitude});

}