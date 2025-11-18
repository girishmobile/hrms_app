import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms/core/hive/user_model.dart';
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
    Timer(const Duration(seconds: 3), () async {
      await checkStatus();
    });

  }

  Future<void> checkStatus() async {
    try {
<<<<<<< HEAD
=======
      // Add a small delay to ensure Hive is ready
      await Future.delayed(const Duration(milliseconds: 300));

      // Try to read cached user; if Hive isn't initialized or box missing this may throw
>>>>>>> 4b367d4 (testing on leavr)
      UserModel? user;
      user = await AppConfigCache.getUserModel();


      final isLoggedIn = user?.data?.user?.id != null;

      final route = isLoggedIn
          ? RouteName.dashboardScreen
          : RouteName.loginScreen;


      if (mounted) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          route,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.loginScreen,
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
<<<<<<< HEAD

=======
        /* decoration: commonBoxDecoration(
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(icImg1)),
        ),*/
>>>>>>> 4b367d4 (testing on leavr)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            commonAssetImage(icAppLogo, width: size.width * 0.7),

          ],
        ),
      ),
    );
  }
}
