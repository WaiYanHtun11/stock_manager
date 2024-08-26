import 'package:intl/intl.dart';

String formatDate(String dateString) {
  // Parse the original date string
  DateTime originalDate = DateTime.parse(dateString);

  // Format the date
  String formattedDate = DateFormat.yMMMMd().format(originalDate);

  return formattedDate;
}

String formatTime(String dateString) {
  // Parse the original date string
  DateTime originalDate = DateTime.parse(dateString);

  // Format the time
  String formattedTime = DateFormat.jm().format(originalDate);

  return formattedTime;
}

String formatDateTime(String isoString) {
  // Parse the ISO 8601 string to a DateTime object
  DateTime dateTime = DateTime.parse(isoString);

  // Define the format you want
  final DateFormat formatter = DateFormat("MMM d, yyyy - h:mm a");

  // Format the DateTime object
  return formatter.format(dateTime);
}
