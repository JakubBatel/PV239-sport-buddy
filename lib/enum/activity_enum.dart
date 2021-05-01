
enum Activity {
  badminton,
  basketball,
  bicycle,
  box,
  football,
  hockey,
  other,
  pingpong,
  rollerblade,
  rugby,
  run,
  ski,
  snowboard,
  tennis,
  volleyball,
  workout


}

final _$ActivityEnumMap = <Activity, dynamic>{
  Activity.badminton: 'badminton',
  Activity.basketball: 'basketball',
  Activity.bicycle: 'bicycle',
  Activity.box: 'box',
  Activity.football: 'football',
  Activity.hockey: 'hockey',
  Activity.other: 'other',
  Activity.pingpong: 'pingpong',
  Activity.rollerblade: 'rollerblade',
  Activity.rugby: 'rugby',
  Activity.run: 'run',
  Activity.ski: 'ski',
  Activity.snowboard: 'snowboard',
  Activity.tennis: 'tennis',
  Activity.volleyball: 'volleyball',
  Activity.workout: 'workout',
};

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
      orElse: () => throw ArgumentError(
          '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

class ActivityConverter {

  static Activity fromJSON(source) => _$enumDecode(_$ActivityEnumMap, source);
  
  static String toJSON(Activity activity) => activity.toString().split('.')[1];

}