class UserContactViewModel {
  Data? data;
  String? message;
  bool? success;

  UserContactViewModel({this.data, this.message, this.success});

  UserContactViewModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class Data {
  int? id;
  String? email;
  String? contactNo;
  String? linkdinUsername;
  String? facebookUsername;
  String? twitterUsername;

  Data(
      {this.id,
        this.email,
        this.contactNo,
        this.linkdinUsername,
        this.facebookUsername,
        this.twitterUsername});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    contactNo = json['contact_no'];
    linkdinUsername = json['linkdin_username'];
    facebookUsername = json['facebook_username'];
    twitterUsername = json['twitter_username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['contact_no'] = contactNo;
    data['linkdin_username'] = linkdinUsername;
    data['facebook_username'] = facebookUsername;
    data['twitter_username'] = twitterUsername;
    return data;
  }
}
