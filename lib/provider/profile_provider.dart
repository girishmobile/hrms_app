import 'dart:io';
import 'package:flutter/material.dart';

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
}
