class LeaveDashboardModel {
  Data? data;
  int? draw;
  int? recordsFiltered;
  int? recordsTotal;

  LeaveDashboardModel(
      {this.data, this.draw, this.recordsFiltered, this.recordsTotal});

  LeaveDashboardModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['draw'] = draw;
    data['recordsFiltered'] = recordsFiltered;
    data['recordsTotal'] = recordsTotal;
    return data;
  }
}

class Data {
  List<DataItem>? data;
  int? count;

  Data({this.data, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataItem>[];
      json['data'].forEach((v) {
        data!.add(DataItem.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class DataItem {
  int? id;
  LeaveDate? leaveDate;
  LeaveDate? leaveEndDate;
  bool? halfDay;
  String? halfDayType;
  String? leaveCount;
  String? status;
  String? reason;
  String? location;
  bool? finalApprove;
  bool? isLeaveWfh;
  dynamic rejectReason;
  UserId? userId;
  LeaveType? leaveType;
  List<LeaveHistory>? leaveHistory;

  DataItem(
      {this.id,
        this.leaveDate,
        this.leaveEndDate,
        this.halfDay,
        this.halfDayType,
        this.leaveCount,
        this.status,
        this.reason,
        this.location,
        this.finalApprove,
        this.isLeaveWfh,
        this.rejectReason,
        this.userId,
        this.leaveType,
        this.leaveHistory});

  DataItem.fromJson(Map<String, dynamic> json) {
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
    location = json['location'];
    finalApprove = json['final_approve'];
    isLeaveWfh = json['is_leave_wfh'];
    rejectReason = json['reject_reason'];
    userId =
    json['user_id'] != null ? UserId.fromJson(json['user_id']) : null;
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
    data['location'] = location;
    data['final_approve'] = finalApprove;
    data['is_leave_wfh'] = isLeaveWfh;
    data['reject_reason'] = rejectReason;
    if (userId != null) {
      data['user_id'] = userId!.toJson();
    }
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

class UserId {
  int? id;
  String? firstname;
  String? lastname;
  String? profileImage;

  UserId({this.id, this.firstname, this.lastname, this.profileImage});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
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
