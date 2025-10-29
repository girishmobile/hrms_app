import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';

import '../../core/constants/image_utils.dart';
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
    redirectToIntro();
  }

  void redirectToIntro() {
    Timer(const Duration(seconds: 5), () async {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteName.loginScreen,
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: Center(
        child: commonAssetImage(
          icAppLogo,
          fit: BoxFit.scaleDown,

          width: size.width * 0.7,
        ),
      ),
    );
  }
}
