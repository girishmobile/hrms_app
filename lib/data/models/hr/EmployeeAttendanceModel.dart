class EmployeeAttendanceModel {
  int? id;
  String? firstname;
  String? contactNo;
  String? lastname;
  String? profileImage;
  String? designation;
  String? officeStartTime;
  String? officeEndTime;
  dynamic hikAttendanceId;
  String? batch;

  EmployeeAttendanceModel(
      {this.id,
        this.firstname,
        this.contactNo,
        this.lastname,
        this.profileImage,
        this.designation,
        this.officeStartTime,
        this.officeEndTime,
        this.hikAttendanceId,
        this.batch});

  EmployeeAttendanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    contactNo = json['contact_no'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
    designation = json['designation'];
    officeStartTime = json['office_start_time'];
    officeEndTime = json['office_end_time'];
    hikAttendanceId = json['hik_attendance_id'];
    batch = json['batch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['contact_no'] = contactNo;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
    data['designation'] = designation;
    data['office_start_time'] = officeStartTime;
    data['office_end_time'] = officeEndTime;
    data['hik_attendance_id'] = hikAttendanceId;
    data['batch'] = batch;
    return data;
  }
}
