class LeaveResponse {
  List<Data>? data;
  int? draw;
  int? recordsFiltered;
  int? recordsTotal;

  LeaveResponse(
      {this.data, this.draw, this.recordsFiltered, this.recordsTotal});

  LeaveResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['draw'] = draw;
    data['recordsFiltered'] = recordsFiltered;
    data['recordsTotal'] = recordsTotal;
    return data;
  }
}

class Data {
  int? id;
  LeaveDate? leaveDate;
  LeaveDate? leaveEndDate;
  bool? halfDay;
  String? halfDayType;
  String? leaveCount;
  String? status;
  String? reason;
  bool? finalApprove;
  int? isLeaveWfh;
  dynamic rejectReason;
  LeaveType? leaveType;
  List<LeaveHistory>? leaveHistory;

  Data(
      {this.id,
        this.leaveDate,
        this.leaveEndDate,
        this.halfDay,
        this.halfDayType,
        this.leaveCount,
        this.status,
        this.reason,
        this.finalApprove,
        this.isLeaveWfh,
        this.rejectReason,
        this.leaveType,
        this.leaveHistory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaveDate = json['leave_date'] != null
        ? LeaveDate.fromJson(json['leave_date'])
        : null;
    leaveEndDate = json['leave_end_date'] != null
        ? LeaveDate.fromJson(json['leave_end_date'])
        : null;
    halfDay = json['half_day'];
    halfDayType = json['half_day_type'];
    leaveCount = json['leave_count'];
    status = json['status'];
    reason = json['reason'];
    finalApprove = json['final_approve'];
    isLeaveWfh = json['is_leave_wfh'];
    rejectReason = json['reject_reason'];
    leaveType = json['leave_type'] != null
        ? LeaveType.fromJson(json['leave_type'])
        : null;
    if (json['leave_history'] != null) {
      leaveHistory = <LeaveHistory>[];
      json['leave_history'].forEach((v) {
        leaveHistory!.add(LeaveHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (leaveDate != null) {
      data['leave_date'] = leaveDate!.toJson();
    }
    if (leaveEndDate != null) {
      data['leave_end_date'] = leaveEndDate!.toJson();
    }
    data['half_day'] = halfDay;
    data['half_day_type'] = halfDayType;
    data['leave_count'] = leaveCount;
    data['status'] = status;
    data['reason'] = reason;
    data['final_approve'] = finalApprove;
    data['is_leave_wfh'] = isLeaveWfh;
    data['reject_reason'] = rejectReason;
    if (leaveType != null) {
      data['leave_type'] = leaveType!.toJson();
    }
    if (leaveHistory != null) {
      data['leave_history'] =
          leaveHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveDate {
  String? date;
  int? timezoneType;
  String? timezone;

  LeaveDate({this.date, this.timezoneType, this.timezone});

  LeaveDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['timezone_type'] = timezoneType;
    data['timezone'] = timezone;
    return data;
  }
}

class LeaveType {
  int? id;
  String? leavetype;

  LeaveType({this.id, this.leavetype});

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leavetype = json['leavetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['leavetype'] = leavetype;
    return data;
  }
}

class LeaveHistory {
  int? id;
  String? msg;
  LeaveDate? createdAt;

  LeaveHistory({this.id, this.msg, this.createdAt});

  LeaveHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
    createdAt = json['created_at'] != null
        ? LeaveDate.fromJson(json['created_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['msg'] = msg;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    return data;
  }
}
