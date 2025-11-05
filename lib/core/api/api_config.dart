import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/hive/app_config_cache.dart';

import '../hive/user_model.dart';

class ApiConfig {
  static String get apiBASEURL => dotenv.env['API_BASE_URL'] ?? '';
  static String get imageBaseUrl => dotenv.env['IMAGE_BASE_URL'] ?? '';

  //=======================user and Login Api
  static String loginAPi = "$apiBASEURL/login";
  static String getUserDetailsBYID = "$apiBASEURL/user/getEmployeeById";
  static String getLeaveData = "$apiBASEURL/leave_application/getSelfLeaveRequiredData";
  static String addLeave = "$apiBASEURL/leave_application/save_leave_application";
  static String leaveCountData = "$apiBASEURL/leave_application/summary";
  static String upcomingLeaveHoliday = "$apiBASEURL/user/getUpcomingBdays";
  static String currentAttendanceRecord = "$apiBASEURL/hikattendance/currentMonthHikAttendanceRecord";
  static String kpiList = "$apiBASEURL/kra-kpi/summary";
  static String uploadProfileImage = "$apiBASEURL/uploadlogo";
  static String updateProfileData = "$apiBASEURL/user/update_employee";
  static String getNotification = "$apiBASEURL/activity_box/getEmpNotifications";
  static String getAllLeave = "$apiBASEURL/datatable/getLeaveRequiredData";
  static String getAttendance = "$apiBASEURL/hikattendance/getUserAttendanceByDate";
  static String updateFCMToken = "$apiBASEURL/user/update-fcm-token";


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
