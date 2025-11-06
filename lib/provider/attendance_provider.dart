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

    print('==start====${start.toIso8601String()}');
    print('==end====${end.toIso8601String()}');

    try {
      final response = await callApi(
        url: ApiConfig.getAttendanceUrl,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        print('=====${json.decode(response)}');

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

        setCustomDateRange(DateTimeRange(start: start, end: end));
        setSelectedDateRange(
          "${start.toLocal().toString().split(' ')[0]} - ${end.toLocal().toString().split(' ')[0]}",
        );

        await _fetchAttendance(start, end);
      }
    }
    /* if (value == "Custom Date") {
      // Use CalendarDatePicker2 inside a dialog
      final List<DateTime?>? result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            contentPadding: EdgeInsets.zero,

           // title: const Text('Select Date Range'),
            content: SizedBox(
              width: 400, // constrain width
              height: 350, //
              // constrain height
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.range,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  selectedDayHighlightColor: Colors.green,
                ),
                value: _customDateRange != null
                    ? [_customDateRange!.start, _customDateRange!.end]
                    : [],
                onValueChanged: (dates) {
                  // do nothing here, final value returned on "OK"
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {

                  // Retrieve selected dates from CalendarDatePicker2
                  final state =
                  context.findAncestorStateOfType<CalendarDatePicker2State>();
                  if (state != null) {
                    Navigator.pop(context, state.selectedDates);
                  } else {
                    Navigator.pop(context, null);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (result != null && result.length == 2 && result[0] != null && result[1] != null) {
        start = result[0]!;
        end = result[1]!;

        setCustomDateRange(DateTimeRange(start: start, end: end));
        setSelectedDateRange(
            "${start.toLocal().toString().split(' ')[0]} - ${end.toLocal().toString().split(' ')[0]}");
        await _fetchAttendance(start, end);
      }
    }*/
    /* if (value == "Custom Date") {
      DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        initialDateRange: _customDateRange,
      );

      if (picked != null) {
        setCustomDateRange(picked);
        setSelectedDateRange(
          "${picked.start.toLocal().toString().split(' ')[0]} - ${picked.end.toLocal().toString().split(' ')[0]}",
        );
        start = picked.start;
        end = picked.end;
        await _fetchAttendance(start, end);
      }
    }*/
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
      {"title": "Days", "value": leave?.presentDays ?? 0, "desc": ''},

      {"title": "Absent", "value": leave?.absentDays ?? 0, "desc": ''},
      {
        "title": "Late",
        "value": (leave?.lateDaysRatio ?? 0).toInt(),
        "desc": '% (0 Days)',
      },
      {"title": "Half Days", "value": leave?.halfDays ?? 0, "desc": ''},

      {
        "title": "Absent Days Ratio",
        "value": (leave?.absentDaysRatio ?? 0).toInt(),
        "desc": '% (0 Days)',
      },
      {
        "title": "Productivity Ratio",
        "value": int.tryParse('${leave?.productivityRatio ?? 0}') ?? 0,
        "desc": '.00%',
      },

      {
        "title": "Office Staffing",
        "value": leave?.officeStaffing ?? 0,
        "desc": '',
      },
      if (leave?.requiredStaffing != null)
        {
          "title": "Required Staffing",
          "value":
              ((leave?.requiredStaffing!.hours ?? 0) * 60 +
              (leave?.requiredStaffing!.minutes ?? 0)),
          "desc": '',
        },
      if (leave?.empStaffing != null)
        {
          "title": "Employee Staffing",
          "value":
              ((leave?.empStaffing!.hours ?? 0) * 60 +
              (leave?.empStaffing!.minutes ?? 0)),
          "desc": '',
        },
    ];
  }
}
