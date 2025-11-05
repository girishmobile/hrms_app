import 'package:flutter/material.dart';
import 'package:hrms/view/add_leave/add_leave_screen.dart';
import 'package:hrms/view/attendance_details/attendance_details_screen.dart';
import 'package:hrms/view/coming_birthday/upcoming_birthday_screen.dart';
import 'package:hrms/view/dashboard/dashboard_screen.dart';
import 'package:hrms/view/holiday/holiday_screen.dart';
import 'package:hrms/view/kpi_details/kpi_details_screen.dart';
import 'package:hrms/view/leave_details/leave_details_screen.dart';
import 'package:hrms/view/notification/notification_screen.dart';
import 'package:hrms/view/splash/splash_screen.dart';

import '../../view/auth/login_screen.dart';
import '../../view/leave_details/leave_details_args.dart';
import 'app_routes.dart';

class RouteGenerate {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return _buildPageRoute(const SplashScreen());

      case RouteName.loginScreen:
        return _buildPageRoute(const LoginScreen());
      case RouteName.dashboardScreen:
        return _buildPageRoute(const DashboardScreen());
      case RouteName.addLeaveScreen:
        return _buildPageRoute(const AddLeaveScreen());
      case RouteName.holidayScreen:
        return _buildPageRoute(const HolidayScreen());
      case RouteName.notificationScreen:
        return _buildPageRoute(const NotificationScreen());
      case RouteName.upcomingBirthdayScreen:
        return _buildPageRoute(const UpcomingBirthdayScreen());
      case RouteName.leaveDetailsScreen:
        final args = settings.arguments as LeaveDetailsArgs;

        return _buildPageRoute(
          LeaveDetailsScreen(title: args.title, color: args.color),
        );

      case RouteName.attendanceDetailsScreen:
        final args = settings.arguments as LeaveDetailsArgs;
        return _buildPageRoute(
          AttendanceDetailsScreen(title: args.title, color: args.color),
        );

      case RouteName.kpiDetailsScreen:
        final args = settings.arguments as LeaveDetailsArgs;
        return _buildPageRoute(
          KpiDetailsScreen(
            title: args.title,
            color: args.color,
            year: args.year,
          ),
        );

      default:
        return _buildPageRoute(const SplashScreen());
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        // Animation starts from bottom (Offset(0, 1)) → center (Offset.zero)
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            // optional fade effect
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
