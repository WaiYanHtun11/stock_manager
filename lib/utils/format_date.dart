import 'package:intl/intl.dart';

String formatDate(String dateString) {
  // Parse the original date string
  DateTime originalDate = DateTime.parse(dateString);

  // Format the date
  String formattedDate = DateFormat.yMMMMd().format(originalDate);

  return formattedDate;
}
