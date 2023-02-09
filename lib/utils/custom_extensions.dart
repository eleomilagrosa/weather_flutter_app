import 'package:intl/intl.dart';

extension CustomDateTimeConverter on DateTime {
  String toMMddyyyy() =>
      DateFormat("MM/dd/yyyy").format(this);
}