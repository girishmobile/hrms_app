import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hrms/data/models/dashboard/current_attendace_model.dart';
import 'package:hrms/data/models/leave/leave_count_data_model.dart';
import 'package:hrms/data/models/notification/notification_model.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/widgets/component.dart';
import '../data/models/dashboard/holiday_birthday_model.dart';
import '../main.dart';

class LeaveModel {
  final String? title;
  final String? desc;
  int? count;
  final Color? bgColor;
  LeaveModel({this.title, this.count, this.bgColor, this.desc});
}

class DashboardProvider with ChangeNotifier {
  int _currentIndex = 2;

  int get currentIndex => _currentIndex;

  String? _appbarTitle;

  String? get appbarTitle => _appbarTitle;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setAppBarTitle(String? value) {
    _appbarTitle = value;
    notifyListeners();
  }

  //=================================Leave ================================

  void setSelectedLeaveType(String type) {
    notifyListeners();
  }

  final List<LeaveModel> _leaves = [
    LeaveModel(title: 'Pending Leaves', count: 5, bgColor: Colors.orange),
    LeaveModel(title: 'Cancel Leaves', count: 3, bgColor: Colors.red),
    LeaveModel(title: 'Approved', count: 10, bgColor: Colors.green),
    LeaveModel(title: 'Reject Leaves', count: 4, bgColor: Colors.grey),
    LeaveModel(title: 'All', count: 22, bgColor: Colors.blue),
    LeaveModel(title: 'Apply Leave', count: 0, bgColor: Colors.redAccent),
  ];

  List<LeaveModel> get leaves => _leaves;

  final List<LeaveModel> _attendanceList = [
    LeaveModel(title: 'Days', count: 1, bgColor: Colors.orange),
    LeaveModel(title: 'Late', count: 0, bgColor: Colors.red),
    LeaveModel(title: 'Absent', count: 0, bgColor: Colors.green),
    LeaveModel(title: 'Half Days', count: 0, bgColor: Colors.grey),
    LeaveModel(
      title: 'Total Office',
      count: 9,
      bgColor: Colors.blue,
      desc: "hrs",
    ),
    LeaveModel(
      title: 'Total worked',
      count: 0,
      bgColor: Colors.redAccent,
      desc: "hrs",
    ),
    LeaveModel(
      title: 'Productivity Ratio',
      count: 0,
      bgColor: Colors.orange,
      desc: ".00%",
    ),
  ];

  List<LeaveModel> get attendanceList => _attendanceList;

  final List<Color> colors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.blue,
    Colors.redAccent,
  ];

  final List<Map<String, dynamic>> allLeaveDetails = [
    {
      "type": "Sick Leave",
      "reason": "Fever",
      "from": "2025-10-01",
      "to": "2025-10-03",
      "days": 3,
      "appliedOn": "2025-09-28",
      "status": "Pending Leaves",
    },
    {
      "type": "Casual Leave",
      "reason": "Family function",
      "from": "2025-09-10",
      "to": "2025-09-12",
      "days": 3,
      "appliedOn": "2025-09-01",
      "status": "Approved",
    },
    {
      "type": "Medical Leave",
      "reason": "Checkup",
      "from": "2025-08-15",
      "to": "2025-08-15",
      "days": 1,
      "appliedOn": "2025-08-13",
      "status": "Cancel Leaves",
    },
    {
      "type": "Unpaid Leave",
      "reason": "Personal Work",
      "from": "2025-07-20",
      "to": "2025-07-21",
      "days": 2,
      "appliedOn": "2025-07-19",
      "status": "Reject Leaves",
    },
    {
      "type": "Sick Leave",
      "reason": "Cold and cough",
      "from": "2025-06-05",
      "to": "2025-06-06",
      "days": 2,
      "appliedOn": "2025-06-04",
      "status": "Approved",
    },
    {
      "type": "Casual Leave",
      "reason": "Marriage ceremony",
      "from": "2025-05-10",
      "to": "2025-05-12",
      "days": 3,
      "appliedOn": "2025-05-05",
      "status": "Pending Leaves",
    },
    {
      "type": "Paternity Leave",
      "reason": "Newborn care",
      "from": "2025-04-01",
      "to": "2025-04-10",
      "days": 10,
      "appliedOn": "2025-03-25",
      "status": "Approved",
    },
    {
      "type": "Unpaid Leave",
      "reason": "Travel abroad",
      "from": "2025-03-15",
      "to": "2025-03-20",
      "days": 6,
      "appliedOn": "2025-03-10",
      "status": "Reject Leaves",
    },
    {
      "type": "Sick Leave",
      "reason": "Migraine",
      "from": "2025-02-01",
      "to": "2025-02-02",
      "days": 2,
      "appliedOn": "2025-01-31",
      "status": "Cancel Leaves",
    },
    {
      "type": "Casual Leave",
      "reason": "Festival celebration",
      "from": "2025-01-10",
      "to": "2025-01-11",
      "days": 2,
      "appliedOn": "2025-01-08",
      "status": "Approved",
    },
    {
      "type": "Medical Leave",
      "reason": "Surgery recovery",
      "from": "2024-12-20",
      "to": "2024-12-25",
      "days": 6,
      "appliedOn": "2024-12-18",
      "status": "Approved",
    },
    {
      "type": "Sick Leave",
      "reason": "Viral infection",
      "from": "2024-11-10",
      "to": "2024-11-12",
      "days": 3,
      "appliedOn": "2024-11-08",
      "status": "Pending Leaves",
    },
    {
      "type": "Unpaid Leave",
      "reason": "House shifting",
      "from": "2024-10-05",
      "to": "2024-10-06",
      "days": 2,
      "appliedOn": "2024-10-04",
      "status": "Cancel Leaves",
    },
    {
      "type": "Casual Leave",
      "reason": "Vacation trip",
      "from": "2024-09-15",
      "to": "2024-09-20",
      "days": 6,
      "appliedOn": "2024-09-10",
      "status": "Approved",
    },
    {
      "type": "Sick Leave",
      "reason": "Back pain",
      "from": "2024-08-02",
      "to": "2024-08-04",
      "days": 3,
      "appliedOn": "2024-08-01",
      "status": "Reject Leaves",
    },
    {
      "type": "Casual Leave",
      "reason": "Friend’s wedding",
      "from": "2024-07-10",
      "to": "2024-07-12",
      "days": 3,
      "appliedOn": "2024-07-08",
      "status": "Pending Leaves",
    },
    {
      "type": "Medical Leave",
      "reason": "Dental treatment",
      "from": "2024-06-05",
      "to": "2024-06-06",
      "days": 2,
      "appliedOn": "2024-06-03",
      "status": "Approved",
    },
    {
      "type": "Unpaid Leave",
      "reason": "Urgent family matter",
      "from": "2024-05-01",
      "to": "2024-05-02",
      "days": 2,
      "appliedOn": "2024-04-30",
      "status": "Reject Leaves",
    },
    {
      "type": "Casual Leave",
      "reason": "Outstation event",
      "from": "2024-03-15",
      "to": "2024-03-17",
      "days": 3,
      "appliedOn": "2024-03-10",
      "status": "Approved",
    },
    {
      "type": "Sick Leave",
      "reason": "Food poisoning",
      "from": "2024-02-05",
      "to": "2024-02-06",
      "days": 2,
      "appliedOn": "2024-02-04",
      "status": "Pending Leaves",
    },
  ];

  final List<Map<String, dynamic>> allKPIDetails = [
    {
      "date": "2025-10-01",
      "targetPoints": 80,
      "actualPoints": 78,
      "remarks": "Slightly below target",
    },
    {
      "date": "2025-10-02",
      "targetPoints": 85,
      "actualPoints": 90,
      "remarks": "Exceeded expectations",
    },
    {
      "date": "2025-10-03",
      "targetPoints": 75,
      "actualPoints": 74,
      "remarks": "Met most goals",
    },
    {
      "date": "2025-09-30",
      "targetPoints": 80,
      "actualPoints": 82,
      "remarks": "Good performance",
    },
    {
      "date": "2025-09-29",
      "targetPoints": 85,
      "actualPoints": 88,
      "remarks": "Achieved above target",
    },
    {
      "date": "2025-08-15",
      "targetPoints": 70,
      "actualPoints": 68,
      "remarks": "Slight shortfall",
    },
    {
      "date": "2025-08-16",
      "targetPoints": 75,
      "actualPoints": 80,
      "remarks": "Improved performance",
    },
    {
      "date": "2025-07-10",
      "targetPoints": 90,
      "actualPoints": 92,
      "remarks": "Excellent work",
    },
    {
      "date": "2025-07-11",
      "targetPoints": 85,
      "actualPoints": 84,
      "remarks": "On track",
    },
    {
      "date": "2025-07-12",
      "targetPoints": 80,
      "actualPoints": 83,
      "remarks": "Good consistency",
    },
  ];

  final List<Map<String, dynamic>> allHolidayDetails = [
    {
      "name": "New Year’s Day",
      "date": "2025-01-01",
      "day": "Wednesday",
      "type": "Public Holiday",
      "description": "Celebration of the New Year.",
      "bgColor": 0xFFE3F2FD, // light blue
    },
    {
      "name": "Republic Day",
      "date": "2025-01-26",
      "day": "Sunday",
      "type": "National Holiday",
      "description": "Commemorates the adoption of the Indian Constitution.",
      "bgColor": 0xFFFFEBEE, // light red
    },
    {
      "name": "Holi",
      "date": "2025-03-14",
      "day": "Friday",
      "type": "Festival Holiday",
      "description": "Festival of colors and joy.",
      "bgColor": 0xFFF3E5F5, // light purple
    },
    {
      "name": "Good Friday",
      "date": "2025-04-18",
      "day": "Friday",
      "type": "Religious Holiday",
      "description": "Commemorates the crucifixion of Jesus Christ.",
      "bgColor": 0xFFE8F5E9, // light green
    },
    {
      "name": "Eid al-Fitr",
      "date": "2025-04-01",
      "day": "Tuesday",
      "type": "Religious Holiday",
      "description": "Marks the end of Ramadan.",
      "bgColor": 0xFFFFF3E0, // light orange
    },
    {
      "name": "May Day",
      "date": "2025-05-01",
      "day": "Thursday",
      "type": "Public Holiday",
      "description": "International Workers’ Day.",
      "bgColor": 0xFFE1F5FE, // light cyan
    },
    {
      "name": "Independence Day",
      "date": "2025-08-15",
      "day": "Friday",
      "type": "National Holiday",
      "description": "Celebrates India’s independence from British rule.",
      "bgColor": 0xFFFFF8E1, // light yellow
    },
    {
      "name": "Raksha Bandhan",
      "date": "2025-08-09",
      "day": "Saturday",
      "type": "Festival Holiday",
      "description": "Celebrates the bond between brothers and sisters.",
      "bgColor": 0xFFFCE4EC, // light pink
    },
    {
      "name": "Ganesh Chaturthi",
      "date": "2025-08-27",
      "day": "Wednesday",
      "type": "Festival Holiday",
      "description": "Celebrates the birth of Lord Ganesha.",
      "bgColor": 0xFFE8EAF6, // light indigo
    },
    {
      "name": "Gandhi Jayanti",
      "date": "2025-10-02",
      "day": "Thursday",
      "type": "National Holiday",
      "description": "Birth anniversary of Mahatma Gandhi.",
      "bgColor": 0xFFE0F2F1, // teal tint
    },
    {
      "name": "Dussehra",
      "date": "2025-10-11",
      "day": "Saturday",
      "type": "Festival Holiday",
      "description": "Victory of good over evil, marking the end of Navratri.",
      "bgColor": 0xFFFFF3E0, // light orange
    },
    {
      "name": "Diwali",
      "date": "2025-10-20",
      "day": "Monday",
      "type": "Festival Holiday",
      "description":
          "Festival of lights symbolizing victory of light over darkness.",
      "bgColor": 0xFFFFFDE7, // light gold
    },
    {
      "name": "Guru Nanak Jayanti",
      "date": "2025-11-05",
      "day": "Wednesday",
      "type": "Religious Holiday",
      "description": "Marks the birth of Guru Nanak Dev Ji.",
      "bgColor": 0xFFE8F5E9, // light green
    },
    {
      "name": "Christmas Day",
      "date": "2025-12-25",
      "day": "Thursday",
      "type": "Religious Holiday",
      "description": "Celebrates the birth of Jesus Christ.",
      "bgColor": 0xFFE3F2FD, // light blue
    },
    {
      "name": "Makar Sankranti",
      "date": "2025-01-14",
      "day": "Tuesday",
      "type": "Festival Holiday",
      "description":
          "Harvest festival marking the transition of the sun into Capricorn.",
      "bgColor": 0xFFFFF8E1, // light yellow
    },
    {
      "name": "Mahashivratri",
      "date": "2025-02-26",
      "day": "Wednesday",
      "type": "Religious Holiday",
      "description": "Festival dedicated to Lord Shiva.",
      "bgColor": 0xFFEDE7F6, // lavender
    },
    {
      "name": "Eid al-Adha",
      "date": "2025-06-07",
      "day": "Saturday",
      "type": "Religious Holiday",
      "description": "Festival of sacrifice celebrated by Muslims.",
      "bgColor": 0xFFFFF3E0, // light orange
    },
    {
      "name": "Janmashtami",
      "date": "2025-08-16",
      "day": "Saturday",
      "type": "Religious Holiday",
      "description": "Celebrates the birth of Lord Krishna.",
      "bgColor": 0xFFE3F2FD, // light blue
    },
    {
      "name": "Muharram",
      "date": "2025-07-06",
      "day": "Sunday",
      "type": "Religious Holiday",
      "description":
          "Islamic New Year and remembrance of the martyrdom of Imam Hussain.",
      "bgColor": 0xFFFFEBEE, // light red
    },
    {
      "name": "Bhai Dooj",
      "date": "2025-10-22",
      "day": "Wednesday",
      "type": "Festival Holiday",
      "description":
          "Celebrates the bond between brothers and sisters after Diwali.",
      "bgColor": 0xFFFCE4EC, // light pink
    },
  ];

  List<Map<String, dynamic>> getLeavesByType(String title) {
    if (title == "All") return allLeaveDetails;
    return allLeaveDetails
        .where(
          (l) => l["status"].toString().toLowerCase() == title.toLowerCase(),
        )
        .toList();
  }

  final List<Map<String, dynamic>> allAttendanceDetails = [
    {
      "date": "2025-10-01",
      "entryTime": "09:15 AM",
      "exitTime": "06:05 PM",
      "workingHours": "8h 50m",
    },
    {
      "date": "2025-10-02",
      "entryTime": "09:10 AM",
      "exitTime": "06:00 PM",
      "workingHours": "8h 50m",
    },
    {
      "date": "2025-10-03",
      "entryTime": "09:05 AM",
      "exitTime": "06:15 PM",
      "workingHours": "9h 10m",
    },
    {
      "date": "2025-09-30",
      "entryTime": "09:20 AM",
      "exitTime": "06:10 PM",
      "workingHours": "8h 50m",
    },
    {
      "date": "2025-09-29",
      "entryTime": "09:30 AM",
      "exitTime": "06:30 PM",
      "workingHours": "9h 00m",
    },
    {
      "date": "2025-08-15",
      "entryTime": "09:45 AM",
      "exitTime": "06:35 PM",
      "workingHours": "8h 50m",
    },
    {
      "date": "2025-08-16",
      "entryTime": "09:00 AM",
      "exitTime": "06:00 PM",
      "workingHours": "9h 00m",
    },
    {
      "date": "2025-07-10",
      "entryTime": "09:10 AM",
      "exitTime": "06:20 PM",
      "workingHours": "9h 10m",
    },
    {
      "date": "2025-07-11",
      "entryTime": "09:05 AM",
      "exitTime": "06:00 PM",
      "workingHours": "8h 55m",
    },
    {
      "date": "2025-07-12",
      "entryTime": "09:00 AM",
      "exitTime": "06:10 PM",
      "workingHours": "9h 10m",
    },
  ];

  final List<Map<String, dynamic>> allBirthdayDetails = [
    {
      "name": "Aarav Sharma",
      "date": "2025-01-05",
      "day": "Sunday",
      "department": "Design",
      "bgColor": 0xFFE3F2FD, // Light Blue (January)
    },
    {
      "name": "Priya Verma",
      "date": "2025-02-18",
      "day": "Tuesday",
      "department": "HR",
      "bgColor": 0xFFFCE4EC, // Pink (February)
    },
    {
      "name": "Rohan Gupta",
      "date": "2025-03-12",
      "day": "Wednesday",
      "department": "Marketing",
      "bgColor": 0xFFE8F5E9, // Green (March)
    },
    {
      "name": "Neha Singh",
      "date": "2025-04-25",
      "day": "Friday",
      "department": "Finance",
      "bgColor": 0xFFFFF3E0, // Orange (April)
    },
    {
      "name": "Karan Patel",
      "date": "2025-05-30",
      "day": "Friday",
      "department": "Sales",
      "bgColor": 0xFFE1F5FE, // Cyan (May)
    },
    {
      "name": "Isha Nair",
      "date": "2025-06-10",
      "day": "Tuesday",
      "department": "IT",
      "bgColor": 0xFFF3E5F5, // Purple (June)
    },
    {
      "name": "Aditya Mehta",
      "date": "2025-07-08",
      "day": "Tuesday",
      "department": "Development",
      "bgColor": 0xFFFFF8E1, // Yellow (July)
    },
    {
      "name": "Sneha Rao",
      "date": "2025-08-20",
      "day": "Wednesday",
      "department": "Support",
      "bgColor": 0xFFE8EAF6, // Indigo (August)
    },
    {
      "name": "Rahul Das",
      "date": "2025-09-03",
      "day": "Wednesday",
      "department": "Operations",
      "bgColor": 0xFFE0F2F1, // Teal (September)
    },
    {
      "name": "Anjali Sharma",
      "date": "2025-10-15",
      "day": "Wednesday",
      "department": "Admin",
      "bgColor": 0xFFFFFDE7, // Light Gold (October)
    },
    {
      "name": "Vikram Singh",
      "date": "2025-11-11",
      "day": "Tuesday",
      "department": "Legal",
      "bgColor": 0xFFFFEBEE, // Light Red (November)
    },
    {
      "name": "Divya Joshi",
      "date": "2025-12-22",
      "day": "Monday",
      "department": "Research",
      "bgColor": 0xFFE8F5E9, // Light Green (December)
    },
  ];

  Color getBirthdayBgColor(DateTime date) {
    switch (date.month) {
      case 1:
        return const Color(0xFFE3F2FD);
      case 2:
        return const Color(0xFFFCE4EC);
      case 3:
        return const Color(0xFFE8F5E9);
      case 4:
        return const Color(0xFFFFF3E0);
      case 5:
        return const Color(0xFFE1F5FE);
      case 6:
        return const Color(0xFFF3E5F5);
      case 7:
        return const Color(0xFFFFF8E1);
      case 8:
        return const Color(0xFFE8EAF6);
      case 9:
        return const Color(0xFFE0F2F1);
      case 10:
        return const Color(0xFFFFFDE7);
      case 11:
        return const Color(0xFFFFEBEE);
      case 12:
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFE0E0E0);
    }
  }

  Color getHolidayBgColor(String type) {
    switch (type.toLowerCase()) {
      case 'national holiday':
        return const Color(0xFFFFF3E0); // Light orange
      case 'festival holiday':
        return const Color(0xFFFCE4EC); // Light pink
      case 'religious holiday':
        return const Color(0xFFE8F5E9); // Light green
      case 'public holiday':
        return const Color(0xFFE3F2FD); // Light blue
      default:
        return const Color(0xFFE0E0E0); // Light grey fallback
    }
  }

  final List<Map<String, dynamic>> monthData = [
    {"month": "January", "icon": Icons.calendar_month_outlined, "percent": 75},
    {"month": "February", "icon": Icons.calendar_month_outlined, "percent": 60},
    {"month": "March", "icon": Icons.calendar_month_outlined, "percent": 82},
    {"month": "April", "icon": Icons.calendar_month_outlined, "percent": 90},
    {"month": "May", "icon": Icons.calendar_month_outlined, "percent": 40},
    {"month": "June", "icon": Icons.calendar_month_outlined, "percent": 55},
    {"month": "July", "icon": Icons.calendar_month_outlined, "percent": 68},
    {"month": "August", "icon": Icons.calendar_month_outlined, "percent": 77},
    {
      "month": "September",
      "icon": Icons.calendar_month_outlined,
      "percent": 84,
    },
    {"month": "October", "icon": Icons.calendar_month_outlined, "percent": 92},
    {"month": "November", "icon": Icons.calendar_month_outlined, "percent": 63},
    {"month": "December", "icon": Icons.calendar_month_outlined, "percent": 88},
  ];

  String _selectedYear = "2025";
  String get selectedYear => _selectedYear;
  void setYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  // default selected year
  List<String> years = ["2021", "2022", "2023", "2024", "2025"];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  HolidayBirthdayModel? _birthdayModel;

  HolidayBirthdayModel? get birthdayModel => _birthdayModel;
  Future<void> getBirthdayHoliday() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.upcomingLeaveHolidayUrl,
        method: HttpMethod.GET,

        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);
        _birthdayModel = HolidayBirthdayModel.fromJson(json.decode(response));

        debugPrint('======$decoded');
        _setLoading(false);
      } else {
        /* showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );*/
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }

  CurrentAttendanceModel? _currentAttendanceModel;

  CurrentAttendanceModel? get currentAttendanceModel => _currentAttendanceModel;
  Future<void> getCurrentAttendanceRecord() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.currentAttendanceRecordUrl,
        method: HttpMethod.GET,

        headers: null,
      );
      debugPrint('======$globalStatusCode');
      if (globalStatusCode == 200) {
        _currentAttendanceModel = CurrentAttendanceModel.fromJson(
          json.decode(response),
        );

        _setLoading(false);
      } else {
        /*showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );*/
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }

  List<NotificationModel> _notificationList = [];

  List<NotificationModel> get notificationList => _notificationList;
  Future<void> getNotification() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getNotificationUrl,
        method: HttpMethod.GET,

        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        // Ensure it's a list
        if (decoded is List) {
          _notificationList = decoded
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        } else {
          _notificationList = [];
        }

        debugPrint('======$decoded');
        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }

  List<LeaveCountDataModel> _leaveCountData = [];

  List<LeaveCountDataModel> get leaveCountData => _leaveCountData;
  Future<void> getLeaveCountData() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.leaveCountDataUrl,
        method: HttpMethod.GET,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        if (decoded is Map<String, dynamic>) {
          _leaveCountData = decoded.entries
              .map((e) => LeaveCountDataModel(title: e.key, count: e.value))
              .toList();
        } else {
          _leaveCountData = [];
        }

        debugPrint('======$decoded');
      } else {
        /* showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );*/
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void printFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
    } catch (e) {
      print('Error fetching FCM token: $e');
    }
  }

  Future<void> updateFCMToken() async {
    _setLoading(true);

    printFcmToken();
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        debugPrint('Error getting FCM token for update: $e');
        fcmToken = null;
      }

      Map<String, dynamic> body = {"fcm_token": fcmToken};
      final response = await callApi(
        url: ApiConfig.updateFCMTokenUrl,
        method: HttpMethod.POST,

        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        debugPrint('======$decoded');
        _setLoading(false);
      } else {
        /*showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );*/
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }
}
