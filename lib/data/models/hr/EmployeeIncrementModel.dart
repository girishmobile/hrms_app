class EmployeeIncrementModel {
  List<Increments>? increments;
  ActiveEmp? activeEmp;
  TotalWfh? totalWfh;
  List<dynamic>? onProbation;
  List<dynamic>? onNotice;
  Jobs? jobs;
  OnlineEmployees? onlineEmployees;

  EmployeeIncrementModel(
      {this.increments,
        this.activeEmp,
        this.totalWfh,
        this.onProbation,
        this.onNotice,
        this.jobs,
        this.onlineEmployees});

  EmployeeIncrementModel.fromJson(Map<String, dynamic> json) {
    if (json['increments'] != null) {
      increments = <Increments>[];
      json['increments'].forEach((v) {
        increments!.add(Increments.fromJson(v));
      });
    }
    activeEmp = json['active_emp'] != null
        ? ActiveEmp.fromJson(json['active_emp'])
        : null;
    totalWfh = json['total_wfh'] != null
        ? TotalWfh.fromJson(json['total_wfh'])
        : null;
    /*if (json['on_probation'] != null) {
      onProbation = <Null>[];
      json['on_probation'].forEach((v) {
        onProbation!.add(new Null.fromJson(v));
      });
    }*/
    /*if (json['on_notice'] != null) {
      onNotice = <Null>[];
      json['on_notice'].forEach((v) {
        onNotice!.add(new Null.fromJson(v));
      });
    }*/
    jobs = json['jobs'] != null ? Jobs.fromJson(json['jobs']) : null;
    onlineEmployees = json['online_employees'] != null
        ? OnlineEmployees.fromJson(json['online_employees'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (increments != null) {
      data['increments'] = increments!.map((v) => v.toJson()).toList();
    }
    if (activeEmp != null) {
      data['active_emp'] = activeEmp!.toJson();
    }
    if (totalWfh != null) {
      data['total_wfh'] = totalWfh!.toJson();
    }
    if (onProbation != null) {
      data['on_probation'] = onProbation!.map((v) => v.toJson()).toList();
    }
    if (onNotice != null) {
      data['on_notice'] = onNotice!.map((v) => v.toJson()).toList();
    }
    if (jobs != null) {
      data['jobs'] = jobs!.toJson();
    }
    if (onlineEmployees != null) {
      data['online_employees'] = onlineEmployees!.toJson();
    }
    return data;
  }
}

class Increments {
  int? id;
  String? firstname;
  String? lastname;
  JoiningDate? joiningDate;
  JoiningDate? incrementDate;
  String? profileImage;

  Increments(
      {this.id,
        this.firstname,
        this.lastname,
        this.joiningDate,
        this.incrementDate,
        this.profileImage});

  Increments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    joiningDate = json['joining_date'] != null
        ? JoiningDate.fromJson(json['joining_date'])
        : null;
    incrementDate = json['increment_date'] != null
        ? JoiningDate.fromJson(json['increment_date'])
        : null;
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    if (joiningDate != null) {
      data['joining_date'] = joiningDate!.toJson();
    }
    if (incrementDate != null) {
      data['increment_date'] = incrementDate!.toJson();
    }
    data['profile_image'] = profileImage;
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

class ActiveEmp {
  int? activeCount;

  ActiveEmp({this.activeCount});

  ActiveEmp.fromJson(Map<String, dynamic> json) {
    activeCount = json['active_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active_count'] = activeCount;
    return data;
  }
}

class TotalWfh {
  int? totalWfh;

  TotalWfh({this.totalWfh});

  TotalWfh.fromJson(Map<String, dynamic> json) {
    totalWfh = json['total_wfh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_wfh'] = totalWfh;
    return data;
  }
}

class Jobs {
  int? totalCandidate;

  Jobs({this.totalCandidate});

  Jobs.fromJson(Map<String, dynamic> json) {
    totalCandidate = json['total_candidate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_candidate'] = totalCandidate;
    return data;
  }
}

class OnlineEmployees {
  int? empCount;

  OnlineEmployees({this.empCount});

  OnlineEmployees.fromJson(Map<String, dynamic> json) {
    empCount = json['emp_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_count'] = empCount;
    return data;
  }
}
