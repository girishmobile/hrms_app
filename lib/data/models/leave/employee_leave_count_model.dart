class EmployeeLeaveCountModel {
  int? id;
  dynamic totalLeaves;
  String? cl;
  String? pl;
  String? sl;
  String? usedUpl;
  bool? employmentStarted;
  bool? oneYearCompleted;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  dynamic deletedAt;

  EmployeeLeaveCountModel(
      {this.id,
        this.cl,
        this.pl,
        this.sl,
        this.totalLeaves,
        this.usedUpl,
        this.employmentStarted,
        this.oneYearCompleted,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  EmployeeLeaveCountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cl = json['cl'];
    pl = json['pl'];
    totalLeaves = json['total_leaves'];
    sl = json['sl'];
    usedUpl = json['used_upl'];
    employmentStarted = json['employment_started'];
    oneYearCompleted = json['one_year_completed'];
    createdAt = json['created_at'] != null
        ? CreatedAt.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? CreatedAt.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cl'] = cl;
    data['pl'] = pl;
    data['sl'] = sl;
    data['total_leaves'] = totalLeaves;
    data['used_upl'] = usedUpl;
    data['employment_started'] = employmentStarted;
    data['one_year_completed'] = oneYearCompleted;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class CreatedAt {
  String? date;
  int? timezoneType;
  String? timezone;

  CreatedAt({this.date, this.timezoneType, this.timezone});

  CreatedAt.fromJson(Map<String, dynamic> json) {
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
