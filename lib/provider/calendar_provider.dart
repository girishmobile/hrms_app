import 'package:flutter/foundation.dart';

class CalendarEvent {
  final String title;
  final String type; // 'attendance', 'leave', 'holiday'
  final DateTime date;

  CalendarEvent({required this.title, required this.type, required this.date});
}
class CalendarProvider extends ChangeNotifier {
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  Map<DateTime, List<Map<String, dynamic>>> get events => _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  CalendarProvider() {
    loadEvents();
  }
  void loadEvents() {
    _events = {
      // Leaves
      DateTime.utc(2025, 1, 10): [{'type': 'leave', 'title': 'Casual Leave'}],
      DateTime.utc(2025, 2, 5): [{'type': 'leave', 'title': 'Medical Leave'}],
      DateTime.utc(2025, 3, 21): [{'type': 'leave', 'title': 'Festival Leave'}],
      DateTime.utc(2025, 5, 15): [{'type': 'leave', 'title': 'Half Day Leave'}],
      DateTime.utc(2025, 6, 4): [{'type': 'leave', 'title': 'Sick Leave'}],
      DateTime.utc(2025, 8, 30): [{'type': 'leave', 'title': 'Vacation Leave'}],

      // Attendance
      DateTime.utc(2025, 1, 2): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 1, 3): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 1, 4): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 1, 6): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 1, 7): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 2, 1): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 2, 3): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 3, 10): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 4, 8): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 5, 6): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 6, 7): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 7, 5): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 8, 1): [{'type': 'attendance', 'title': 'Present'}],
      DateTime.utc(2025, 9, 2): [{'type': 'attendance', 'title': 'Present'}],

      // Holidays
      DateTime.utc(2025, 1, 26): [{'type': 'holiday', 'title': 'Republic Day'}],
      DateTime.utc(2025, 8, 15): [{'type': 'holiday', 'title': 'Independence Day'}],
      DateTime.utc(2025, 10, 2): [{'type': 'holiday', 'title': 'Gandhi Jayanti'}],
      DateTime.utc(2025, 12, 25): [{'type': 'holiday', 'title': 'Christmas Day'}],
    };


    notifyListeners();
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    notifyListeners();
  }


  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }
}
