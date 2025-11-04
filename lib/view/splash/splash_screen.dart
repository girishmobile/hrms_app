import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';

import '../../core/constants/image_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart';
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
      UserModel? user = await AppConfigCache.getUserModel();

      if (user?.data?.user?.id == null) {
        // User not logged in → go to login screen
        Timer(const Duration(seconds: 5), () {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.loginScreen,
                (Route<dynamic> route) => false,
          );
        });
        return;
      } else {
        // User logged in → go to home/dashboard
        Timer(const Duration(seconds: 3), () {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.dashboardScreen,
                (Route<dynamic> route) => false,
          );
        });
      }
    } catch (e) {
      print('Error loading user: $e');
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
