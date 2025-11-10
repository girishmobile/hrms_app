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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  Future<void> init() async {
    await checkStatus();
  }

  Future<void> checkStatus() async {
    try {
      // Add a small delay to ensure Hive is ready
      await Future.delayed(const Duration(milliseconds: 500));

      // Try to read cached user; if Hive isn't initialized or box missing this may throw
      var user;
      try {
        user = await AppConfigCache.getUserModel();
      } catch (e) {
        debugPrint(
          'Error reading user from cache (treating as logged out): $e',
        );
        user = null;
      }

      final isLoggedIn = user?.data?.user?.id != null;
      final delay = Duration(seconds: isLoggedIn ? 3 : 5);
      final route = isLoggedIn
          ? RouteName.dashboardScreen
          : RouteName.loginScreen;

      await Future.delayed(delay);

      if (mounted) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          route,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint('Critical error in splash: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to start app. Please try again.';
          _isLoading = false;
        });
      }

      // After showing error for 2 seconds, try to navigate to login
      await Future.delayed(const Duration(seconds: 2));
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
      body: Container(
        width: size.width,
        height: size.height,
        decoration: commonBoxDecoration(
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(icImg1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            commonAssetImage(icAppLogo, width: size.width * 0.7),
            if (_isLoading) ...[
              const SizedBox(height: 32),
              showLoaderList(),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
