
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