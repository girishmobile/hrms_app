import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hrms/data/models/dashboard/leave_model.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/widgets/component.dart';
import '../data/models/leave/LeaveModel.dart';
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
  final List<Leave> _leaves = [
    Leave(
      type: "Sick Leave",
      reason: "Fever",
      fromDate: DateTime(2025, 10, 1),
      toDate: DateTime(2025, 10, 3),
      days: 3,
      appliedOn: DateTime(2025, 9, 28),
      status: LeaveStatus.pending,
    ),
    Leave(
      type: "Casual Leave",
      reason: "Family function",
      fromDate: DateTime(2025, 9, 10),
      toDate: DateTime(2025, 9, 12),
      days: 3,
      appliedOn: DateTime(2025, 9, 1),
      status: LeaveStatus.approved,
    ),
  ];

  LeaveStatus? _filterStatus;

  List<Leave> get leaves {
    if (_filterStatus == null) return _leaves;
    return _leaves.where((l) => l.status == _filterStatus).toList();
  }

  void setFilterStatus(LeaveStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  bool _isHalfDay = false;
  int leaveDays = 0;
  bool get isHalfDay => _isHalfDay;
  void setHalfDay(bool value) {
    _isHalfDay = value;
    notifyListeners();
  }
  //Date

  DateTime? _fromDate;
  DateTime? _toDate;

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

var tetReason=TextEditingController();
  void setFromDate(DateTime date) {
    _fromDate = date;

    // Reset toDate if it's before fromDate
    if (toDate != null && toDate!.isBefore(fromDate!)) {
      _toDate = null;
      leaveDays = 0;
    }

    _calculateDays();
    notifyListeners();
  }

  void setToDate(DateTime date) {
    _toDate = date;
    _calculateDays();
    notifyListeners();
  }

  void _calculateDays() {
    if (fromDate != null && toDate != null) {
      leaveDays = toDate!.difference(fromDate!).inDays + 1;
    } else {
      leaveDays = 0;
    }
  }

  void clearDates() {
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }
  String ?_leaveType ;

  String ? get leaveType => _leaveType;
  void setLeaveType(String value) {
    _leaveType = value;
    notifyListeners();
  }
  void clearLeaveType() {
    _fromDate = null;
    _toDate = null;
    leaveDays = 0;
    _leaveType = null;
    _isHalfDay = false;
    tetReason.clear();
    notifyListeners();
  }


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
  LeaveModel ? _leaveModel;

  LeaveModel? get leaveModel => _leaveModel;
  Future<void> getLeaveData({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getLeaveData,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);
        _leaveModel = LeaveModel.fromJson(json.decode(response));

        print('======$decoded');
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
        url: ApiConfig.addLeave,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );
      print('==globalStatusCode===$globalStatusCode');
      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        print('=====$decoded');
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

  LeaveTypes ? get selectedLeaveType => _selectedLeaveType;

  void setSelectedLeaveType(LeaveTypes type) {
    _selectedLeaveType = type;
    notifyListeners();
  }
}
