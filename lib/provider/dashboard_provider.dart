import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/constants/string_utils.dart';
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

  String? _appbarTitle=home;

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




  final List<Map<String, dynamic>> allAttendanceDetails = [

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
