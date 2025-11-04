import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/hive/app_config_cache.dart';

import '../hive/user_model.dart';

class ApiConfig {
  static String get apiBASEURL => dotenv.env['API_BASE_URL'] ?? '';

  //=======================user and Login Api
  static String loginAPi = "$apiBASEURL/login";
  static String getUserDetailsBYID = "$apiBASEURL/user/getEmployeeById";
  static String getLeaveData = "$apiBASEURL/leave_application/getSelfLeaveRequiredData";
  static String addLeave = "$apiBASEURL/leave_application/save_leave_application";
  static String upcomingLeaveHoliday = "$apiBASEURL/user/getUpcomingBdays";


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
