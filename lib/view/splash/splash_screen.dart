import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';

import '../../core/constants/image_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/routes/app_routes.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  Future<void> init() async {
    checkStatus();
  }

  void checkStatus() async {
    try {
      final user = await AppConfigCache.getUserModel();
      final isLoggedIn = user?.data?.user?.id != null;

      // Delay based on login status
      final delay = Duration(seconds: isLoggedIn ? 3 : 5);
      final route = isLoggedIn
          ? RouteName.dashboardScreen
          : RouteName.loginScreen;

      Timer(delay, () {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          route,
          (Route<dynamic> route) => false,
        );
      });
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: commonBoxDecoration(
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(icImg1)),
        ),
        child: Center(
          child: commonAssetImage(icAppLogo, width: size.width * 0.7),
        ),
      ),
    );
  }
}
