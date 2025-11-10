import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hrms/data/models/dashboard/current_attendace_model.dart';
import 'package:hrms/data/models/leave/leave_count_data_model.dart';
import 'package:hrms/data/models/notification/notification_model.dart';
import 'package:hrms/data/models/work/my_work_model.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/widgets/component.dart';
import '../data/models/dashboard/holiday_birthday_model.dart';
import '../data/models/hub_staff_model/hun_staff_model.dart';
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





  final List<Color> colors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.blue,
    Colors.redAccent,
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
        method: HttpMethod.get,

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
        method: HttpMethod.get,

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
        method: HttpMethod.get,

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
        method: HttpMethod.get,
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
   await FirebaseMessaging.instance.getToken();
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
        method: HttpMethod.post,

        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        debugPrint('======$decoded');
        _setLoading(false);
      } else {

      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> deleteNotification({required int id}) async {
    _setLoading(true);
    try {

      Map<String, dynamic> body ={
        "id":id
      };
      final response = await callApi(
        url: ApiConfig.deleteNotificationUrl,
        method: HttpMethod.post,

        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        debugPrint('======$decoded');
        _setLoading(false);
      } else {

      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }
  HubStaffModel ?_hubStaffModel;

  HubStaffModel?  get hubStaffModel => _hubStaffModel;
  Future<void> getHubStaffLog() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.hubStaffLogURL,
        method: HttpMethod.get,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);


        _hubStaffModel = HubStaffModel.fromJson(
          json.decode(response),
        );

        _setLoading(false);
        debugPrint('=ddsdds=====$decoded');
      } else {

      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  MyWorkModel ?_myWorkModel;

  MyWorkModel?  get myWorkModel => _myWorkModel;
  Future<void> getMYHours({required int id}) async {
    _setLoading(true);
    try {

      Map<String, dynamic> body ={
        "id":id
      };
      final response = await callApi(
        url: ApiConfig.getMyHoursURL,
        method: HttpMethod.post,

        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {

        _myWorkModel = MyWorkModel.fromJson(  json.decode(response),);


        _setLoading(false);
      } else {

      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint('=====e=$e');
      _setLoading(false);
    }
  }
}
