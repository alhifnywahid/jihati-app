import 'package:intl/intl.dart';

String formatTime(DateTime? time) {
  if (time == null) return '-';
  return DateFormat.Hm('id_ID').format(time);
}
