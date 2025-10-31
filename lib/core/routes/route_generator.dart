import 'package:flutter/material.dart';
import 'package:hrms/view/add_leave/add_leave_screen.dart';
import 'package:hrms/view/attendance_details/attendance_details_screen.dart';
import 'package:hrms/view/coming_birthday/upcoming_birthday_screen.dart';
import 'package:hrms/view/dashboard/dashboard_screen.dart';
import 'package:hrms/view/holiday/holiday_screen.dart';
import 'package:hrms/view/kpi_details/kpi_details_screen.dart';
import 'package:hrms/view/leave_details/leave_details_screen.dart';
import 'package:hrms/view/splash/splash_screen.dart';

import '../../view/auth/login_screen.dart';
import '../../view/leave_details/leave_details_args.dart';
import 'app_routes.dart';

class RouteGenerate {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.dashboardScreen:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RouteName.addLeaveScreen:
        return MaterialPageRoute(builder: (_) => const AddLeaveScreen());
      case RouteName.holidayScreen:
        return MaterialPageRoute(builder: (_) => const HolidayScreen());

      case RouteName.upcomingBirthdayScreen:
        return MaterialPageRoute(builder: (_) => const UpcomingBirthdayScreen());
      case RouteName.leaveDetailsScreen:
        final args = settings.arguments as LeaveDetailsArgs;
        return MaterialPageRoute(
          builder: (_) => LeaveDetailsScreen(
            title: args.title,
            color: args.color,
          ),
        );

      case RouteName.attendanceDetailsScreen:
        final args = settings.arguments as LeaveDetailsArgs;
        return MaterialPageRoute(
          builder: (_) => AttendanceDetailsScreen(
            title: args.title,
            color: args.color,
          ),
        );

      case RouteName.kpiDetailsScreen:
        final args = settings.arguments as LeaveDetailsArgs;
        return MaterialPageRoute(
          builder: (_) => KpiDetailsScreen(
            title: args.title,
            year: args.year,
            color: args.color,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
