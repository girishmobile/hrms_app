import 'package:flutter/material.dart';

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
}
