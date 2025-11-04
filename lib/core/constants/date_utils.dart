
import 'package:intl/intl.dart';

String formatDateTime(String isoString) {
  try {
    DateTime dateTime = DateTime.parse(isoString).toLocal(); // converts to local time
    return DateFormat('EEEE \'at\' hh:mm a').format(dateTime);
  } catch (e) {
    return ''; // return empty string if parsing fails
  }
}

String timeAgo(String createdAt) {
  try {
    DateTime dateTime = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    Duration diff = now.difference(dateTime);

    if (diff.inDays >= 365) {
      int years = (diff.inDays / 365).floor();
      return years == 1 ? "1 year ago" : "$years years ago";
    } else if (diff.inDays >= 30) {
      int months = (diff.inDays / 30).floor();
      return months == 1 ? "1 month ago" : "$months months ago";
    } else if (diff.inDays >= 1) {
      return diff.inDays == 1 ? "1 day ago" : "${diff.inDays} days ago";
    } else if (diff.inHours >= 1) {
      return diff.inHours == 1 ? "1 hour ago" : "${diff.inHours} hours ago";
    } else if (diff.inMinutes >= 1) {
      return diff.inMinutes == 1 ? "1 minute ago" : "${diff.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  } catch (e) {
    return ""; // If parsing fails
  }
}

String formatCreatedAt(String createdAt, {String source = "Draft Orders"}) {
  try {
    // Parse ISO 8601 string into DateTime
    DateTime dateTime = DateTime.parse(createdAt);

    // Format date (example: 13 Sept 2025)
    String datePart = DateFormat("d MMM yyyy").format(dateTime);

    // Format time (example: 7:19 pm)
    String timePart = DateFormat("h:mm a").format(dateTime).toLowerCase();

    // Final string
    return "$datePart at $timePart from $source";
  } catch (e) {
    return createdAt; // fallback if parsing fails
  }


}


String formatString(String? timestamp) {
  if (timestamp == null || timestamp.isEmpty) return "N/A";

  // Parse the string into DateTime
  DateTime? dateTime = DateTime.tryParse(timestamp);
  if (dateTime == null) return "N/A";

  // Format the DateTime
  return DateFormat("d MMMM yyyy, h:mm a").format(dateTime.toLocal());
}


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
String formatHolidayDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final day = date.day;
    final month = DateFormat('MMMM').format(date); // e.g. December
    final year = DateFormat('yyyy').format(date);  // e.g. 2025
    final weekday = DateFormat('EEE').format(date); // e.g. Thu

    // Get suffix like 1st, 2nd, 3rd, 4th...
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

    return '$day$suffix $month | $weekday $year';
  } catch (_) {
    return dateString;
  }
}
String formatHolidayDate1(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final day = date.day;
    final month = DateFormat('MMM').format(date); // e.g. December
   // final year = DateFormat('yyyy').format(date);  // e.g. 2025
    //final weekday = DateFormat('EEE').format(date); // e.g. Thu

    // Get suffix like 1st, 2nd, 3rd, 4th...
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

    return '$day$suffix $month';
  } catch (_) {
    return dateString;
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
  //  final month = DateFormat('MMM').format(date); // e.g. December
    // final year = DateFormat('yyyy').format(date);  // e.g. 2025
    //final weekday = DateFormat('EEE').format(date); // e.g. Thu

    // Get suffix like 1st, 2nd, 3rd, 4th...
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
