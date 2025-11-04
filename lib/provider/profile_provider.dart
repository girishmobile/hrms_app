import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/data/models/profile/ProfileModel.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/widgets/component.dart';
import '../main.dart';

class ProfileProvider extends ChangeNotifier {
  File? _pickedFile;
  String? _imageUrl;

  File? get pickedFile => _pickedFile;

  String? get imageUrl => _imageUrl;

  void setNetworkImage(String url) {
    _imageUrl = url;
    notifyListeners();
  }

  void setPickedFile(File file) {
    _pickedFile = file;
    notifyListeners();
  }

  void clearImage() {
    _pickedFile = null;
    _imageUrl = null;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }


  ProfileModel ? _profileModel;

  ProfileModel? get profileModel => _profileModel;
  Future<void> getUserDetails({required Map<String, dynamic> body}) async {
    _setLoading(true);

    print('===$body');
    try {
      final response = await callApi(
        url: ApiConfig.getUserDetailsBYID,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {

        _profileModel = ProfileModel.fromJson(json.decode(response));

        setNetworkImage(_profileModel?.profileImage??'');
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
    } catch (e) {
      print('===$e');
      _setLoading(false);
    }
  }
}
