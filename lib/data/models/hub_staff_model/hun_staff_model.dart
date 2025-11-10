class HubStaffModel {
  bool? success;
  String? weekTotal;
  List<Days>? days;

  HubStaffModel({this.success, this.weekTotal, this.days});

  HubStaffModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    weekTotal = json['week_total'];
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['week_total'] = weekTotal;
    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  String? date;
  String? dayNum;
  String? dayName;
  String? month;
  String? time;

  Days({this.date, this.dayNum, this.dayName, this.month, this.time});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dayNum = json['day_num'];
    dayName = json['day_name'];
    month = json['month'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['day_num'] = dayNum;
    data['day_name'] = dayName;
    data['month'] = month;
    data['time'] = time;
    return data;
  }
}
