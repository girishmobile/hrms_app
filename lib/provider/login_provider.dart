import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/hive/app_config_cache.dart';
import '../core/hive/user_model.dart';
import '../core/routes/app_routes.dart';
import '../core/widgets/component.dart';
import '../main.dart';

class LoginProvider with ChangeNotifier {
  final tetEmail = TextEditingController();
  final tetPassword = TextEditingController();

  final tetCurrentPassword = TextEditingController();
  final tetNewPassword = TextEditingController();
  final tetConfirmPassword = TextEditingController();
  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  bool _obscureCurrentPassword = true;

  bool get obscureCurrentPassword => _obscureCurrentPassword;

  bool _obscureNewPassword = true;

  bool get obscureNewPassword => _obscureNewPassword;

  bool _obscureConfirmPassword = true;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void togglePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }


  void toggleCurrentPassword() {
    _obscureCurrentPassword = !_obscureCurrentPassword;
    notifyListeners();
  }
  void toggleNewPassword() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
    resetState();
  }

  void resetState() {
    tetEmail.clear();
    tetConfirmPassword.clear();
    tetNewPassword.clear();
    tetCurrentPassword.clear();
    tetPassword.clear();
    _obscurePassword = true;

    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loginApi({required Map<String, dynamic> body}) async {
    print("body: $body");

    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.loginUrl,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        if (decoded['response'] == "success") {
          final userModel = UserModel.fromJson(
            Map<String, dynamic>.from(decoded),
          );
          await AppConfigCache.saveUserModel(userModel);

          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.dashboardScreen,
            (Route<dynamic> route) => false,
          );
          resetState();
        } else {
          showCommonDialog(
            showCancel: false,
            title: "Error",
            context: navigatorKey.currentContext!,
            content: "Invalid email or password...!",
          );
        }
        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> forgotPassword({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.forgotPasswordUrl,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);


        if(decoded['response']=="success"){
          resetState();
          Future.microtask(() {
            final context = navigatorKey.currentContext;
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Password reset link has been sent to your email address',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            }

            // ✅ Redirect after short delay
            Future.delayed(const Duration(seconds: 2), () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RouteName.loginScreen,
                    (route) => false,
              );
            });
          });



        }
        else
        {
          showCommonDialog(
            showCancel: false,
            title: "Error",
            context: navigatorKey.currentContext!,
            content: "Invalid email or password...!",
          );
        }
        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> updatePassword({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.userUpdatePassword,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );


      print('${ json.decode(response)}');
      print('${ body}');
      if (globalStatusCode == 200) {
        final decoded = json.decode(response);


        if(decoded!="Not Update"){
          resetState();
          Future.microtask(() {
            final context = navigatorKey.currentContext;
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Password updated successfully',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            }

            // ✅ Redirect after short delay
            Future.delayed(const Duration(seconds: 2), () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RouteName.loginScreen,
                    (route) => false,
              );
            });
          });



        }
        else
        {
          showCommonDialog(
            showCancel: false,
            title: "Error",
            context: navigatorKey.currentContext!,
            content: "Failed to update password",
          );
        }
        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }
}
