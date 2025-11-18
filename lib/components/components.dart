import 'package:flutter/material.dart';

Color getStatusColor(String title) {
  switch (title.toLowerCase()) {
    case "pending":
      return Colors.orange;
    case "accept":
      return Colors.green;
    case "cancel":
      return Colors.red;
    case "rejected":
      return Colors.indigo;
    case "all":
      return Colors.blue;
    default:
      return Colors.grey; // fallback
  }
}
