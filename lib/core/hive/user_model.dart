class UserModel {
  String? response;
  Data? data;

  UserModel({this.response, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    data = json['data'] != null
        ? Data.fromJson(Map<String, dynamic>.from(json['data']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response'] = response;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  User? user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null
        ? User.fromJson(Map<String, dynamic>.from(json['user']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? firstname;
  String? lastname;
  dynamic profileImage;
  String? email;
  int? id;
  String? employeeId;
  List<String>? permission;
  dynamic profile;
  Role? role;
  int? locationId;
  BatchData? batchData;

  User({
    this.firstname,
    this.lastname,
    this.profileImage,
    this.email,
    this.id,
    this.employeeId,
    this.permission,
    this.profile,
    this.role,
    this.locationId,
    this.batchData,
  });

  User.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
    email = json['email'];
    id = json['id'];
    employeeId = json['employee_id'];
    permission = (json['permission'] as List<dynamic>?)?.cast<String>();
    profile = json['profile'];
    role = json['role'] != null
        ? Role.fromJson(Map<String, dynamic>.from(json['role']))
        : null;
    locationId = json['location_id'];
    batchData = json['batch_data'] != null
        ? BatchData.fromJson(Map<String, dynamic>.from(json['batch_data']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
    data['email'] = email;
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['permission'] = permission;
    data['profile'] = profile;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    data['location_id'] = locationId;
    if (batchData != null) {
      data['batch_data'] = batchData!.toJson();
    }
    return data;
  }
}

class Role {
  String? name;
  int? id;

  Role({this.name, this.id});

  Role.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class BatchData {
  int? id;
  String? workingDays;
  dynamic altSat;

  BatchData({this.id, this.workingDays, this.altSat});

  BatchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workingDays = json['working_days'];
    altSat = json['alt_sat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['working_days'] = workingDays;
    data['alt_sat'] = altSat;
    return data;
  }
}