class KpiDetailsModel {
  List<EmployeeData>? data;
 /* int? draw;
  int? recordsFiltered;
  int? recordsTotal;*/

  KpiDetailsModel({this.data, /*this.draw, this.recordsFiltered, this.recordsTotal*/});

  KpiDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => EmployeeData.fromJson(e))
          .toList();
    } else {
      data = [];
    }
/*    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];*/
  }
}

class EmployeeData {
  int? id;
  int? teamId;
  int? empId;
  String? firstname;
  String? lastname;
  String? profileImage;
  KraKpi? kraKpi;
  //List<EmployeeData>? childMembers;
  bool? checkChild;

  EmployeeData({
    this.id,
    this.teamId,
    this.empId,
    this.firstname,
    this.lastname,
    this.profileImage,
    this.kraKpi,
   // this.childMembers,
    this.checkChild,
  });

  EmployeeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    empId = json['emp_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];

    // ✅ Handle kra_kpi being object OR list
    if (json['kra_kpi'] is Map<String, dynamic>) {
      kraKpi = KraKpi.fromJson(json['kra_kpi']);
    } else {
      kraKpi = null;
    }

    // ✅ Handle child_members
  /*  if (json['child_members'] != null) {
      childMembers = (json['child_members'] as List)
          .map((v) => EmployeeData.fromJson(v))
          .toList();
    } else {
      childMembers = [];
    }*/

    checkChild = json['check_child'];
  }
}

class KraKpi {
  int? id;
  DateTime? date;
  String? targetValue;
  String? actualValue;
  String? remarks;

  KraKpi({
    this.id,
    this.date,
    this.targetValue,
    this.actualValue,
    this.remarks,
  });

  KraKpi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // ✅ Extract nested date
    if (json['date'] != null && json['date'] is Map) {
      date = DateTime.tryParse(json['date']['date']);
    }
    targetValue = json['target_value'];
    actualValue = json['actual_value'];
    remarks = json['remarks'];
  }
}
