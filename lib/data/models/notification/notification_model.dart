class NotificationModel {
  int? id;
  String? title;
  String? details;
  bool? isRead;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  dynamic deletedAt;

  NotificationModel(
      {this.id,
        this.title,
        this.details,
        this.isRead,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    details = json['details'];
    isRead = json['is_read'];
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
    data['title'] = title;
    data['details'] = details;
    data['is_read'] = isRead;
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
