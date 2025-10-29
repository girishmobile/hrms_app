import 'package:flutter/material.dart';
import 'package:hrms/view/add_leave/add_leave_screen.dart';
import 'package:hrms/view/dashboard/dashboard_screen.dart';
import 'package:hrms/view/leave_details/leave_details_screen.dart';
import 'package:hrms/view/splash/splash_screen.dart';

import '../../view/auth/login_screen.dart';
import '../../view/leave_details/LeaveDetailsArgs.dart';
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
      case RouteName.leaveDetailsScreen:
        final args = settings.arguments as LeaveDetailsArgs;
        return MaterialPageRoute(
          builder: (_) => LeaveDetailsScreen(
            title: args.title,
            color: args.color,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
