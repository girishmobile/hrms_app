class CurrentAttendanceModel {
  int? presentDays;
  int? lateDays;
  int? absentDays;
  int? halfDays;
  EmpStaffing? empStaffing;

  CurrentAttendanceModel(
      {this.presentDays,
        this.lateDays,
        this.absentDays,
        this.halfDays,
        this.empStaffing});

  CurrentAttendanceModel.fromJson(Map<String, dynamic> json) {
    presentDays = json['presentDays'];
    lateDays = json['lateDays'];
    absentDays = json['absentDays'];
    halfDays = json['halfDays'];
    empStaffing = json['emp_staffing'] != null
        ? EmpStaffing.fromJson(json['emp_staffing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['presentDays'] = presentDays;
    data['lateDays'] = lateDays;
    data['absentDays'] = absentDays;
    data['halfDays'] = halfDays;
    if (empStaffing != null) {
      data['emp_staffing'] = empStaffing!.toJson();
    }
    return data;
  }
}

class EmpStaffing {
  int? hours;
  int? minutes;

  EmpStaffing({this.hours, this.minutes});

  EmpStaffing.fromJson(Map<String, dynamic> json) {
    hours = json['hours'];
    minutes = json['minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hours'] = hours;
    data['minutes'] = minutes;
    return data;
  }
}
