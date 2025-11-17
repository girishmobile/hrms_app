import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/provider/attendance_provider.dart';
import 'package:hrms/provider/calendar_provider.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:hrms/provider/hotline_provider.dart';
import 'package:hrms/provider/kpi_provider.dart';
import 'package:hrms/provider/leave_provider.dart';
import 'package:hrms/provider/login_provider.dart';
import 'package:hrms/provider/profile_provider.dart';
import 'package:hrms/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/firebase/firebase_options.dart';
import 'core/firebase/notification_service.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/theme/app_theme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log(
    "📩 BG Notification received: ${message.messageId}, data: ${message.data}",
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
  ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
  ChangeNotifierProvider<LeaveProvider>(create: (_) => LeaveProvider()),
  ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
  ChangeNotifierProvider<CalendarProvider>(create: (_) => CalendarProvider()),
  ChangeNotifierProvider<KpiProvider>(create: (_) => KpiProvider()),
  ChangeNotifierProvider<AttendanceProvider>(
    create: (_) => AttendanceProvider(),
  ),
  ChangeNotifierProvider<HotlineProvider>(create: (_) => HotlineProvider()),
];

Future<void> _initializeFirebase() async {
  int attempts = 0;
  const maxAttempts = 3;

  while (attempts < maxAttempts) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return;
    } catch (e) {
      attempts++;
      if (attempts == maxAttempts) rethrow;
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start with environment variables
  await dotenv.load(fileName: ".env");

  bool servicesInitialized = false;

  try {
    // Initialize core services

    await _initializeFirebase();

    // Initialize notifications after Firebase
    await NotificationService.initializeApp(navigatorKey: navigatorKey);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    servicesInitialized = true;
  } catch (e, s) {
    debugPrint('🔥 Critical initialization error: $e\n$s');
    // We'll continue to show UI even if services fail
  }

  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(
        navigatorKey: navigatorKey,
        servicesInitialized: servicesInitialized,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.navigatorKey,
    required this.servicesInitialized,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final bool servicesInitialized;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'HRMS',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
      initialRoute: RouteName.splashScreen,
      onGenerateRoute: RouteGenerate.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: themeProvider.themeMode,
    );
  }
}
