import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String getYYYYMMDD() => DateFormat("yyyy-MM-dd").format(toLocal());
  String getDate() => DateFormat("dd MMMM yyyy").format(toLocal());
  String getDay() => DateFormat("EEEE").format(toLocal());
  String getDateWithDay() => DateFormat("EEEE dd MMM. yyyy").format(toLocal());
  String getTime() => DateFormat("hh:mm a").format(toLocal());
  String getDateTime() => DateFormat("yy-MM-dd hh:mm a").format(toLocal());
}
