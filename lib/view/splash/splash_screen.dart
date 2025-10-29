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
      body: SizedBox(
        width: size.width,
        height: size.height,
        /*decoration: commonBoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,

              opacity: 0.9,
              image: AssetImage(  icSplash,))
        ),*/
        child: SizedBox(
          width: size.width,
          height: size.height,
          //color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            
            child: commonAssetImage(icAppLogo,width: size.width*0.7)/*commonText(text: "Welcome to HRMS",fontSize: 28 ,color: Colors.white,fontWeight: FontWeight.w800)*/,
          ),
        ),
      ),
    );
  }
}
