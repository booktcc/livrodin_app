import 'package:intl/intl.dart';

String dateToHour(DateTime date) {
  var formatter = DateFormat("dd/MM/yy HH:mm", 'pt_BR');
  return formatter.format(date);
}
