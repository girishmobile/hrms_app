import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/hive/app_config_cache.dart';

import '../hive/user_model.dart';

class ApiConfig {
  static String get apiBASEURL => dotenv.env['API_BASE_URL'] ?? '';
  static String get imageBaseUrl => dotenv.env['IMAGE_BASE_URL'] ?? '';

  //=======================user and Login Api
  static String loginUrl = "$apiBASEURL/login";
  static String forgotPasswordUrl = "$apiBASEURL/forgotPassword";
  static String getUserDetailsByIdUrl= "$apiBASEURL/user/getEmployeeById";
  static String getLeaveDataUrl = "$apiBASEURL/leave_application/getSelfLeaveRequiredData";
  static String addLeaveUrl = "$apiBASEURL/leave_application/save_leave_application";
  static String saveLeaveData = "$apiBASEURL/leave_application/save_leave_application";
  static String leaveCountDataUrl = "$apiBASEURL/leave_application/summary";
  static String upcomingLeaveHolidayUrl = "$apiBASEURL/user/getUpcomingBdays";
  static String currentAttendanceRecordUrl = "$apiBASEURL/hikattendance/currentMonthHikAttendanceRecord";
  static String kpiListUrl = "$apiBASEURL/kra-kpi/summary";
  static String uploadProfileImageUrl = "$apiBASEURL/uploadlogo";
  static String updateProfileDataUrl = "$apiBASEURL/user/update_employee";
  static String getNotificationUrl = "$apiBASEURL/activity_box/getEmpNotifications";
  static String getAllLeaveUrl = "$apiBASEURL/datatable/getLeaveRequiredData";
  static String getAllListingLeaveUrl = "$apiBASEURL/datatable/getAllLeaves";
  static String getAttendanceUrl = "$apiBASEURL/hikattendance/getUserAttendanceByDate";
  static String updateFCMTokenUrl = "$apiBASEURL/user/update-fcm-token";
  static String calenderUrl = "$apiBASEURL/dashboard/getLeavesSelfDashboard";
  static String deleteLeaveUrl = "$apiBASEURL/leave_application/delete_leave_application";
  static String userUpdatePasswordURL = "$apiBASEURL/user/update_user_password";
  static String deleteNotificationUrl = "$apiBASEURL/activity_box/deleteNotification";
  static String hubStaffLogURL = "$apiBASEURL/user/getHubstaffLogs";
  static String getMyHoursURL = "$apiBASEURL/project-manage/getSelfProjects";
  static String hotlineCountUrl = "$apiBASEURL/attendance/hotline-count";
  static String departmentUrl = "$apiBASEURL/department/get_all_department";
  static String getAllDesignationUrl = "$apiBASEURL/designation/get_all_designation";
  static String hotlineUrl = "$apiBASEURL/attendance/hotline";
  static String kpiDetailsUrl = "$apiBASEURL/kra-kpi/month-details";
  static String getUserDetailsBYIDUrl = "$apiBASEURL/user/getEmpDetailsById";
  static String getUserImpressionsUrl = "$apiBASEURL/impressions/update-profile-view";
  static String approvedLeaveUrl = "$apiBASEURL/leave_application/update_accept_status";
  static String rejectLeaveUrl = "$apiBASEURL/leave_application/update_reject_status";
  static String getEmployeeCountLeaveUrl = "$apiBASEURL/user_leave/getLeaveByEmp";
  static String getCurrentMonthIncrementEmpUrl = "$apiBASEURL/dashboard/getCurrentMonthIncrementEmp";
  static String getHikAttendanceUrl = "$apiBASEURL/dashboard/getHikAttendanceDashboard";
  static String getLeaveDataDashboardUrl = "$apiBASEURL/dashboard/getLeaveDataDashboard";
  static String getAllUserLeavesUrl = "$apiBASEURL/datatable/getAllUserLeaves";



  //==========================================================Shopify API=================================================================================================================

  static Future<Map<String, String>> getCommonHeaders() async {

    UserModel? user = await AppConfigCache.getUserModel();
    return {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer ${user?.data?.token??''}',
    };
  }

}
