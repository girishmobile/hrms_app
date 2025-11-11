class UserDetailsBYIDModel {
  int? id;
  String? firstname;
  String? lastname;
  String? employeeId;
  String? about;
  String? companyEmail;
  bool? isWfhAllowed;
  JoiningDate? joiningDate;
  bool? userExitStatus;
  JoiningDate? dateOfBirth;
  String? emergencyContactNo;
  String? profileImage;
  Designation? designation;
  /*List<Null>? userCommitteeList;
  List<Null>? userTagList;*/
  dynamic impId;

  UserDetailsBYIDModel({
    this.id,
    this.firstname,
    this.lastname,
    this.employeeId,
    this.about,
    this.companyEmail,
    this.isWfhAllowed,
    this.joiningDate,
    this.userExitStatus,
    this.dateOfBirth,
    this.emergencyContactNo,
    this.profileImage,
    this.designation,
    /*  this.userCommitteeList,
        this.userTagList,*/
    this.impId,
  });

  UserDetailsBYIDModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    employeeId = json['employee_id']?.toString(); // 🔥 FIXED HERE
    about = json['about'];
    companyEmail = json['company_email'];
    isWfhAllowed = json['is_wfh_allowed'];
    joiningDate = json['joining_date'] != null
        ? JoiningDate.fromJson(json['joining_date'])
        : null;
    userExitStatus = json['user_exit_status'];
    dateOfBirth = json['date_of_birth'] != null
        ? JoiningDate.fromJson(json['date_of_birth'])
        : null;
    emergencyContactNo = json['emergency_contact_no'];
    profileImage = json['profile_image'];
    designation = json['designation'] != null
        ? Designation.fromJson(json['designation'])
        : null;
    /*  if (json['user_committee_list'] != null) {
      userCommitteeList = <Null>[];
      json['user_committee_list'].forEach((v) {
        userCommitteeList!.add(new Null.fromJson(v));
      });
    }
    if (json['user_tag_list'] != null) {
      userTagList = <Null>[];
      json['user_tag_list'].forEach((v) {
        userTagList!.add(new Null.fromJson(v));
      });
    }*/
    impId = json['imp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['employee_id'] = employeeId;
    data['about'] = about;
    data['company_email'] = companyEmail;
    data['is_wfh_allowed'] = isWfhAllowed;
    if (joiningDate != null) {
      data['joining_date'] = joiningDate!.toJson();
    }
    data['user_exit_status'] = userExitStatus;
    if (dateOfBirth != null) {
      data['date_of_birth'] = dateOfBirth!.toJson();
    }
    data['emergency_contact_no'] = emergencyContactNo;
    data['profile_image'] = profileImage;
    if (designation != null) {
      data['designation'] = designation!.toJson();
    }
    /*  if (this.userCommitteeList != null) {
      data['user_committee_list'] =
          this.userCommitteeList!.map((v) => v.toJson()).toList();
    }
    if (this.userTagList != null) {
      data['user_tag_list'] = this.userTagList!.map((v) => v.toJson()).toList();
    }*/
    data['imp_id'] = impId;
    return data;
  }
}

class JoiningDate {
  String? date;
  int? timezoneType;
  String? timezone;

  JoiningDate({this.date, this.timezoneType, this.timezone});

  JoiningDate.fromJson(Map<String, dynamic> json) {
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

class Designation {
  int? id;
  String? name;

  Designation({this.id, this.name});

  Designation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
