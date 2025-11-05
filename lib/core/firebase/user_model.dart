import 'dart:convert';

class UserModel {
  String? token;
  String? sId;
  String? email;
  String? displayName;
  dynamic  phone;
  dynamic  avatar;
  bool? active;
  String? createdAt;
  String? updatedAt;
  String? role;
  String? type;
  String? description;
  String? country;
  String? countryCode;

  UserModel(
      {this.token,
        this.sId,
        this.email,
        this.displayName,
        this.phone,
        this.avatar,
        this.active,
        this.createdAt,
        this.updatedAt,
        this.countryCode,
        this.role,
        this.type,
        this.description,
        this.country});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    sId = json['_id'];
    email = json['email'];
    displayName = json['displayName'];
    type = json['type'];
    phone = json['phone'];
    avatar = json['avatar'];
    active = json['active'];
    createdAt = json['createdAt'];
    createdAt = json['createdAt'];
    countryCode = json['countryCode'];
    role = json['role'];
    description = json['description'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['_id'] = sId;
    data['email'] = email;
    data['displayName'] = displayName;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['active'] = active;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['countryCode'] = countryCode;
    data['role'] = role;
    data['description'] = description;
    data['country'] = country;
    data['type'] = type;
    return data;
  }

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));
}
