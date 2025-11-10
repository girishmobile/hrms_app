import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:hrms/data/models/attendance/attendance_model.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/widgets/component.dart';
import '../main.dart';

class AttendanceProvider extends ChangeNotifier {
  String _selectedDateRange = '';
  DateTimeRange? _customDateRange;

  String get selectedDateRange => _selectedDateRange;

  DateTimeRange? get customDateRange => _customDateRange;

  void setSelectedDateRange(String value) {
    _selectedDateRange = value;
    notifyListeners();
  }

  void setCustomDateRange(DateTimeRange range) {
    _customDateRange = range;
    notifyListeners();
  }

  AttendanceModel? _attendanceModel;

  AttendanceModel? get attendanceModel => _attendanceModel;

  Future<void> _fetchAttendance(DateTime start, DateTime end) async {
    _setLoading(true);

    Map<String, dynamic> body = {
      "dataTablesParameters": {
        "draw": 1,
        "columns": [
          {
            "data": 0,
            "name": "date",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 1,
            "name": "entry_time",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 2,
            "name": "exit_time",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 3,
            "name": "break_time",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 4,
            "name": "working_hours",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
        ],
        "order": [],
        "start": 0,
        "length": 10,
        "search": {"value": "", "regex": false},
      },
      "dateRange": {
        "start_date": start.toIso8601String(),
        "end_date": end.toIso8601String(),
      },
    };


    try {
      final response = await callApi(
        url: ApiConfig.getAttendanceUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {

        _attendanceModel = AttendanceModel.fromJson(json.decode(response));
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: "Something went wrong",
        );
      }
    } catch (e) {
      debugPrint("Error fetching attendance: $e");
    }

    _setLoading(false);
  }

  Future<void> initializeTodayAttendance() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day);
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    setSelectedDateRange("Today");
    await _fetchAttendance(start, end);
  }

  void handleDateRangeSelection(BuildContext context, String value) async {
    DateTime start;
    DateTime end;
    if (value == "Custom Date") {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),

        selectedDayHighlightColor: Colors.green,
        closeDialogOnCancelTapped: true,
        closeDialogOnOkTapped: true,
        /*selectedDates: _customDateRange != null
            ? [_customDateRange!.start, _customDateRange!.end]
            : [],*/
      );

      final List<DateTime?>? result = await showCalendarDatePicker2Dialog(
        context: context,
        config: config,
        dialogSize: const Size(350, 400),
        borderRadius: BorderRadius.circular(15),
      );

      if (result != null &&
          result.length == 2 &&
          result[0] != null &&
          result[1] != null) {
        DateTime start = result[0]!;
        DateTime end = result[1]!;
        String startDate = "${start.toIso8601String().split('T')[0]}T00:00:00+05:30";
        String endDate = "${end.toIso8601String().split('T')[0]}T23:59:59+05:30";

        setCustomDateRange(DateTimeRange(start: start, end: end));
        setSelectedDateRange(
          "${start.toLocal().toString().split(' ')[0]} - ${end.toLocal().toString().split(' ')[0]}",
        );


        notifyListeners();
        await _fetchAttendance(
          DateTime.parse(startDate),
          DateTime.parse(endDate),
        );
      }
    }

    else {
      setSelectedDateRange(value);

      DateTime now = DateTime.now();
      end = now;

      switch (value) {
        case "Today":
          start = DateTime(now.year, now.month, now.day);
          end = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case "Yesterday":
          start = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: 1));
          end = DateTime(
            now.year,
            now.month,
            now.day,
            23,
            59,
            59,
          ).subtract(Duration(days: 1));
          break;
        case "Last 7 Days":
          start = now.subtract(Duration(days: 6));
          break;
        case "Last 30 Days":
          start = now.subtract(Duration(days: 29));
          break;
        case "This Month":
          start = DateTime(now.year, now.month, 1);
          break;
        case "Last Month":
          DateTime firstDayThisMonth = DateTime(now.year, now.month, 1);
          start = DateTime(
            firstDayThisMonth.year,
            firstDayThisMonth.month - 1,
            1,
          );
          end = firstDayThisMonth.subtract(Duration(days: 1));
          break;
        default:
          start = now;
      }

      await _fetchAttendance(start, end);
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
  List<Map<String, dynamic>> get attendanceGridItems {
    if (_attendanceModel?.data?.leaveData == null) return [];

    final leave = _attendanceModel?.data?.leaveData;

    return [
      {
        "title": "Days",
        "value": leave?.presentDays ?? 0,
        "desc": '',
        "color": const Color(0xFF4CAF50), // Green
      },
      {
        "title": "Absent",
        "value": leave?.absentDays ?? 0,
        "desc": '',
        "color": const Color(0xFFF44336), // Red
      },
      {
        "title": "Late",
        "value": (leave?.lateDaysRatio ?? 0).toInt(),
        "desc": '% (0 Days)',
        "color": const Color(0xFFFF9800), // Orange
      },
      {
        "title": "Half Days",
        "value": leave?.halfDays ?? 0,
        "desc": '',
        "color": const Color(0xFF9C27B0), // Purple
      },
      {
        "title": "Absent Days Ratio",
        "value": (leave?.absentDaysRatio ?? 0).toInt(),
        "desc": '% (0 Days)',
        "color": const Color(0xFF03A9F4), // Light Blue
      },
      {
        "title": "Productivity Ratio",
        "value": int.tryParse('${leave?.productivityRatio ?? 0}') ?? 0,
        "desc": '.00%',
        "color": const Color(0xFF009688), // Teal
      },
      {
        "title": "Office Staffing",
        "value": leave?.officeStaffing ?? 0,
        "desc": '',
        "color": const Color(0xFF673AB7), // Deep Purple
      },
      if (leave?.requiredStaffing != null)
        {
          "title": "Required Staffing",
          "value": ((leave?.requiredStaffing!.hours ?? 0) * 60 +
              (leave?.requiredStaffing!.minutes ?? 0)),
          "desc": '',
          "color": const Color(0xFF2196F3), // Blue
        },
      if (leave?.empStaffing != null)
        {
          "title": "Employee Staffing",
          "value": ((leave?.empStaffing!.hours ?? 0) * 60 +
              (leave?.empStaffing!.minutes ?? 0)),
          "desc": '',
          "color": const Color(0xFFE91E63), // Pink
        },
    ];
  }

}
