class EmployeeLeaveBalanceModel {
  List<Data>? data;
  int? draw;
  int? recordsFiltered;
  int? recordsTotal;

  EmployeeLeaveBalanceModel(
      {this.data, this.draw, this.recordsFiltered, this.recordsTotal});

  EmployeeLeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['draw'] = draw;
    data['recordsFiltered'] = recordsFiltered;
    data['recordsTotal'] = recordsTotal;
    return data;
  }
}

class Data {
  int? id;
  int? empId;
  String? firstname;
  String? lastname;
  String? profileImage;
  bool? userExitStatus;
  String? balance;
  String? cl;
  String? pl;
  String? sl;
  String? usedUpl;

  Data(
      {this.id,
        this.empId,
        this.firstname,
        this.lastname,
        this.profileImage,
        this.userExitStatus,
        this.balance,
        this.cl,
        this.pl,
        this.sl,
        this.usedUpl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empId = json['emp_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
    userExitStatus = json['user_exit_status'];
    balance = json['balance'];
    cl = json['cl'];
    pl = json['pl'];
    sl = json['sl'];
    usedUpl = json['used_upl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emp_id'] = empId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
    data['user_exit_status'] = userExitStatus;
    data['balance'] = balance;
    data['cl'] = cl;
    data['pl'] = pl;
    data['sl'] = sl;
    data['used_upl'] = usedUpl;
    return data;
  }
}
