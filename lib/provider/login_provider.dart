import 'dart:convert';

import 'package:flutter/cupertino.dart';

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
  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    resetState();
  }

  void resetState() {
    tetEmail.clear();
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


        if(decoded['response']=="success"){
          final userModel = UserModel.fromJson(
            Map<String, dynamic>.from(decoded),
          );
          await AppConfigCache.saveUserModel(userModel);


          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.dashboardScreen,
                (Route<dynamic> route) => false,
          );
          resetState();
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
}
