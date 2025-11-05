import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrms/provider/attendance_provider.dart';
import 'package:hrms/provider/calendar_provider.dart';
import 'package:hrms/provider/dashboard_provider.dart';
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

@pragma('vm:entry-point') // important for background isolate
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
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
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await NotificationService.initializeApp(navigatorKey: navigatorKey);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e, s) {
    debugPrint('🔥 Initialization error: $e\n$s');
  }

  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'HRMS',

      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
      initialRoute: RouteName.splashScreen,
      // home: AdminDashboardScreen(),
      onGenerateRoute: RouteGenerate.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: themeProvider.themeMode,
    );
  }
}
