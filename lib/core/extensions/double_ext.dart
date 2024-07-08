import 'package:intl/intl.dart';

extension DoubleExt on double {
  String toEuro() => NumberFormat.simpleCurrency(name: "€").format(this);
}
