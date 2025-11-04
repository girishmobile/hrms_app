class HolidayBirthdayModel {
  List<Birthdays>? birthdays;
  List<Holidays>? holidays;

  HolidayBirthdayModel({this.birthdays, this.holidays});

  HolidayBirthdayModel.fromJson(Map<String, dynamic> json) {
    if (json['birthdays'] != null) {
      birthdays = <Birthdays>[];
      json['birthdays'].forEach((v) {
        birthdays!.add(Birthdays.fromJson(v));
      });
    }
    if (json['holidays'] != null) {
      holidays = <Holidays>[];
      json['holidays'].forEach((v) {
        holidays!.add(Holidays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (birthdays != null) {
      data['birthdays'] = birthdays!.map((v) => v.toJson()).toList();
    }
    if (holidays != null) {
      data['holidays'] = holidays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Birthdays {
  int? id;
  String? firstname;
  String? lastname;
  String? profileImage;
  DateOfBirth? dateOfBirth;
  String? department;
  String? designation;

  Birthdays(
      {this.id,
        this.firstname,
        this.lastname,
        this.profileImage,
        this.dateOfBirth,
        this.department,
        this.designation});

  Birthdays.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
    dateOfBirth = json['date_of_birth'] != null
        ? DateOfBirth.fromJson(json['date_of_birth'])
        : null;
    department = json['department'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
    if (dateOfBirth != null) {
      data['date_of_birth'] = dateOfBirth!.toJson();
    }
    data['department'] = department;
    data['designation'] = designation;
    return data;
  }
}

class DateOfBirth {
  String? date;
  int? timezoneType;
  String? timezone;

  DateOfBirth({this.date, this.timezoneType, this.timezone});

  DateOfBirth.fromJson(Map<String, dynamic> json) {
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

class Holidays {
  int? id;
  String? eventName;
  int? year;
  String? description;
  DateOfBirth? startDate;
  int? isCompanyEvent;
  DateOfBirth? endDate;
  String? holidayImage;
  DateOfBirth? createdAt;
  DateOfBirth? updatedAt;
  dynamic deletedAt;

  Holidays(
      {this.id,
        this.eventName,
        this.year,
        this.description,
        this.startDate,
        this.isCompanyEvent,
        this.endDate,
        this.holidayImage,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Holidays.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    year = json['year'];
    description = json['description'];
    startDate = json['start_date'] != null
        ? DateOfBirth.fromJson(json['start_date'])
        : null;
    isCompanyEvent = json['is_company_event'];
    endDate = json['end_date'] != null
        ? DateOfBirth.fromJson(json['end_date'])
        : null;
    holidayImage = json['holiday_image'];
    createdAt = json['created_at'] != null
        ? DateOfBirth.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? DateOfBirth.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event_name'] = eventName;
    data['year'] = year;
    data['description'] = description;
    if (startDate != null) {
      data['start_date'] = startDate!.toJson();
    }
    data['is_company_event'] = isCompanyEvent;
    if (endDate != null) {
      data['end_date'] = endDate!.toJson();
    }
    data['holiday_image'] = holidayImage;
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
