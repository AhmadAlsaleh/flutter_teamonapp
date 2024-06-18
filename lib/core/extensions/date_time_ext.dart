import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String getYYYYMMDD() => DateFormat("yyyy-MM-dd").format(this);
  String getDate() => DateFormat("dd MMMM yyyy").format(this);
  String getDay() => DateFormat("EEEE").format(this);
  String getDateWithDay() => DateFormat("EEEE dd MMM. yyyy").format(this);
  String getTime() => DateFormat("hh:mm a").format(this);
  String getDateTime() => DateFormat("yy-MM-dd hh:mm a").format(this);
}
