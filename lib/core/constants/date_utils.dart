
import 'package:intl/intl.dart';


String formatDate(String? date, {String format = "dd-MMM-yy"}) {
  if (date == null || date.isEmpty) return '';
  try {
    final parsed = DateTime.parse(date);
    return DateFormat(format).format(parsed);
  } catch (_) {
    return date;
  }
}

Map<String, String> formatDateSplit(String? date) {
  if (date == null || date.isEmpty) return {'top': '', 'bottom': ''};
  try {
    final parsed = DateTime.parse(date);
    return {
      'top': DateFormat('dd').format(parsed),
      'bottom': DateFormat('MMM-yy').format(parsed),
    };
  } catch (_) {
    return {'top': date, 'bottom': ''};
  }
}

String formatWeek(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final weekday = DateFormat('EEE').format(date); // e.g. Thu


    return weekday;
  } catch (_) {
    return dateString;
  }
}
String formatMonth(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final month = DateFormat('MMMM').format(date); // e.g. December


    return month;
  } catch (_) {
    return dateString;
  }
}
String formatDay(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final day = date.day;
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    return '$day$suffix ';
  } catch (_) {

    return dateString;
  }
}

String calculateWorkDuration(String? joiningDate) {
  if (joiningDate == null || joiningDate.isEmpty) return '';

  try {
    final joinDate = DateTime.parse(joiningDate);
    final now = DateTime.now();

    int years = now.year - joinDate.year;
    int months = now.month - joinDate.month;
    int days = now.day - joinDate.day;

    // Adjust negatives
    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    // Build readable text
    final parts = <String>[];
    if (years > 0) parts.add('$years year${years > 1 ? 's' : ''}');
    if (months > 0) parts.add('$months month${months > 1 ? 's' : ''}');
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');

    return parts.isEmpty ? 'Today' : '${parts.join(', ')} ago';
  } catch (e) {
    return '';
  }
}
