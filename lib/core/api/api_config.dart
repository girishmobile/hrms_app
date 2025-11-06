import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/hive/app_config_cache.dart';

import '../hive/user_model.dart';

class ApiConfig {
  static String get apiBASEURL => dotenv.env['API_BASE_URL'] ?? '';
  static String get imageBaseUrl => dotenv.env['IMAGE_BASE_URL'] ?? '';

  //=======================user and Login Api
  static String loginUrl = "$apiBASEURL/login";
  static String getUserDetailsByIdUrl= "$apiBASEURL/user/getEmployeeById";
  static String getLeaveDataUrl = "$apiBASEURL/leave_application/getSelfLeaveRequiredData";
  static String addLeaveUrl = "$apiBASEURL/leave_application/save_leave_application";
  static String leaveCountDataUrl = "$apiBASEURL/leave_application/summary";
  static String upcomingLeaveHolidayUrl = "$apiBASEURL/user/getUpcomingBdays";
  static String currentAttendanceRecordUrl = "$apiBASEURL/hikattendance/currentMonthHikAttendanceRecord";
  static String kpiListUrl = "$apiBASEURL/kra-kpi/summary";
  static String uploadProfileImageUrl = "$apiBASEURL/uploadlogo";
  static String updateProfileDataUrl = "$apiBASEURL/user/update_employee";
  static String getNotificationUrl = "$apiBASEURL/activity_box/getEmpNotifications";
  static String getAllLeaveUrl = "$apiBASEURL/datatable/getLeaveRequiredData";
  static String getAttendanceUrl = "$apiBASEURL/hikattendance/getUserAttendanceByDate";
  static String updateFCMTokenUrl = "$apiBASEURL/user/update-fcm-token";


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
