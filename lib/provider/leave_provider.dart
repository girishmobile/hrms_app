import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/widgets/component.dart';
import '../data/models/leave/LeaveListingModel.dart';
import '../data/models/leave/all_leave_model.dart';
import '../data/models/leave/leave_model.dart';
import '../main.dart';

enum LeaveStatus { pending, approved, cancelled, rejected }

class Leave {
  final String type;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final int days;
  final DateTime appliedOn;
  final LeaveStatus status;

  Leave({
    required this.type,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.appliedOn,
    required this.status,
  });
}

class LeaveProvider with ChangeNotifier {
  bool _isHalfDay = false;
  double leaveDays = 0; // change from int to double
  String _selectedHalfType = "First Half";

  String get selectedHalfType => _selectedHalfType;

  bool get isHalfDay => _isHalfDay;

  void setSelectedHalfType(String value) {
    _selectedHalfType = value;
    notifyListeners();
  }

  //Date

  DateTime? _fromDate;
  DateTime? _toDate;

  DateTime? get fromDate => _fromDate;

  DateTime? get toDate => _toDate;

  var tetReason = TextEditingController();

  void setFromDate(DateTime date) {
    _fromDate = date;

    // Reset toDate if it's before fromDate
    if (toDate != null && toDate!.isBefore(fromDate!)) {
      _toDate = null;
    }

    _calculateDays();
    notifyListeners();
  }

  void setToDate(DateTime date) {
    _toDate = date;

    // If range is more than 1 day, turn off half-day
    if (_fromDate != null && toDate!.difference(_fromDate!).inDays > 0) {
      _isHalfDay = false;
      _selectedHalfType = '';
    }

    _calculateDays();
    notifyListeners();
  }

  void _calculateDays() {
    if (_fromDate != null && _toDate != null) {
      int fullDays = _toDate!.difference(_fromDate!).inDays + 1;

      // If half-day is selected and only 1 day
      leaveDays = (_isHalfDay && fullDays == 1) ? 0.5 : fullDays.toDouble();
    } else if (_fromDate != null && _toDate == null && _isHalfDay) {
      leaveDays = 0.5;
    } else {
      leaveDays = 0;
    }
  }

  void setHalfDay(bool value) {
    // Only allow half-day if fromDate == toDate or toDate is null
    if (fromDate != null &&
        toDate != null &&
        toDate!.difference(fromDate!).inDays > 0) {
      _isHalfDay = false; // cannot set half-day on multiple days
    } else {
      _isHalfDay = value;
    }

    _calculateDays();
    notifyListeners();
  }

  void clearDates() {
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }

  String? _leaveType;

  String? get leaveType => _leaveType;

  void setLeaveType(String value) {
    _leaveType = value;
    notifyListeners();
  }

  final tetRejectReason = TextEditingController();

  void clearLeaveType() {
    _fromDate = null;
    _toDate = null;
    leaveDays = 0;
    _leaveType = null;
    _isHalfDay = false;
    tetReason.clear();
    tetRejectReason.clear();
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  LeaveModel? _leaveModel;

  LeaveModel? get leaveModel => _leaveModel;

  Future<void> getLeaveData({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getLeaveDataUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        _leaveModel = LeaveModel.fromJson(json.decode(response));

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

  Future<void> addLeaveAPI({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.addLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        if (decoded == "created") {
          showCommonDialog(
            title: "Success",
            context: navigatorKey.currentContext!,
            content: "Leave applied successfully!",
            showCancel: false,
            onPressed: () {
              Navigator.of(navigatorKey.currentContext!).pop(true);
            },
          );

          clearLeaveType();
        } else {
          showCommonDialog(
            title: "Message",
            context: navigatorKey.currentContext!,
            content: decoded,
            showCancel: false,
          );
        }

        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> updateLeaveAPI({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.saveLeaveData,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        if (decoded == "created") {
          showCommonDialog(
            title: "Success",
            context: navigatorKey.currentContext!,
            content: "Leave applied successfully!",
            showCancel: false,
          );

          clearLeaveType();
        } else {
          showCommonDialog(
            title: "Message",
            context: navigatorKey.currentContext!,
            content: decoded,
            showCancel: false,
          );
        }

        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }

  LeaveTypes? _selectedLeaveType;

  LeaveTypes? get selectedLeaveType => _selectedLeaveType;

  void setSelectedLeaveType(LeaveTypes type) {
    _selectedLeaveType = type;
    notifyListeners();
  }


  LeaveResponse? _allLeaveModel;

  LeaveResponse? get allLeaveModel => _allLeaveModel;

  Future<void> getAllLeave({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getAllLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);
        _allLeaveModel = LeaveResponse.fromJson(decoded);
      } else {
        // Show error dialog
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
    } catch (e) {
      // Print full error with stacktrace for better debugging
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  LeaveDashboardModel? _leaveDashboardModel;

  LeaveDashboardModel? get leaveDashboardModel => _leaveDashboardModel;
  Future<void> getAllListingLeave() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getAllListingLeaveUrl,
        method: HttpMethod.get,

        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);
        _leaveDashboardModel = LeaveDashboardModel.fromJson(decoded);
      } else {
        // Show error dialog
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      _setLoading(false);
    } catch (e) {
      // Print full error with stacktrace for better debugging
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteLeave({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.deleteLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        _setLoading(false);
      } else {
        // Show error dialog
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
        _setLoading(false);
      }
    } catch (e) {
      // Print full error with stacktrace for better debugging
      debugPrint("Error while fetching leave data: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> approvedLeave({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      await callApi(
        url: ApiConfig.approvedLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      debugPrint("Error while fetching leave data: $body");
      debugPrint("Error while fetching leave data: $globalStatusCode");

      if (globalStatusCode == 200) {
        _setLoading(false);
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text("Leave approved successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        getAllListingLeave();
      } else {
        // Show error dialog
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
        _setLoading(false);
      }
    } catch (e) {
      // Print full error with stacktrace for better debugging
      debugPrint("Error while fetching leave data: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> rejectLeave({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      await callApi(
        url: ApiConfig.rejectLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      debugPrint("Error while fetching leave data: $body");
      debugPrint("Error while fetching leave data: $globalStatusCode");

      if (globalStatusCode == 200) {
        _setLoading(false);
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text("Leave rejected successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        tetRejectReason.clear();
        getAllListingLeave();
      } else {
        // Show error dialog
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
        _setLoading(false);
      }
    } catch (e) {
      // Print full error with stacktrace for better debugging
      debugPrint("Error while fetching leave data: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  final List<Color> colors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.blue,
    Colors.redAccent,
  ];
}
