class LeaveDashboardModel {
  int todayLeavesCount;
  int recentLeavesCount;
  int earlyLeavesCount;

  List todayLeaves;
  List recentLeaves;
  List earlyLeaves;

  LeaveDashboardModel({
    required this.todayLeavesCount,
    required this.recentLeavesCount,
    required this.earlyLeavesCount,
    required this.todayLeaves,
    required this.recentLeaves,
    required this.earlyLeaves,
  });

  factory LeaveDashboardModel.fromJson(Map<String, dynamic> json) {
    return LeaveDashboardModel(
      todayLeavesCount: json["today_leaves_count"] ?? 0,
      recentLeavesCount:
      json["recent_leaves"] != null ? (json["recent_leaves"] as List).length : 0,
      earlyLeavesCount:
      json["early_leaves"] != null ? (json["early_leaves"] as List).length : 0,

      todayLeaves: json["today_leaves"] ?? [],
      recentLeaves: json["recent_leaves"] ?? [],
      earlyLeaves: json["early_leaves"] ?? [],
    );
  }
}
