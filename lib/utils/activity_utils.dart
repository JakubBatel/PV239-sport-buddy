import 'package:sport_buddy/enum/activity_enum.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:sport_buddy/model/event_model.dart';

String getActivityName(Activity activity) {
  return EnumToString.convertToString(activity);
}

Activity getActivityFromString(String activity) {
  return EnumToString.fromString(Activity.values, activity);
}

String getActivityIconPath(Activity activity) {
  return 'assets/icons_png/${getActivityName(activity)}.png';
}