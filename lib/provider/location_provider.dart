// Flutter onboarding screen using Provider to manage location and IP fetching state.
// Save this file as lib/screens/onboarding_location_ip.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hrms/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../core/hive/app_config_cache.dart';

// ----------------------------- PROVIDER CLASS -----------------------------
class LocationProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;
  bool loading = false;
  String? locationError;
  String? _ipAddress;
  String? get ipAddress => _ipAddress;
  String? currentAddress;
  Position? position;
  void setIpAddress(String value) {
    _ipAddress = value;
    notifyListeners();
  }

  void setPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    /* final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);*/
  }

/*  Future<void> requestPermissionsAndFetchData({required bool isAddress}) async {
    loading = true;
    notifyListeners();
    try {
      Position position = await _getCurrentLocation();
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      if(isAddress){
        currentAddress = await _getAddressFromLatLng(position);
        print('Address: $currentAddress');

      }
      loading = false;
      notifyListeners();

      //await getIpAddress();
    } catch (e) {
      print('Error: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }*/
  Future<void> requestPermissionsAndFetchData({required bool isAddress}) async {
    loading = true;
    notifyListeners();

    try {
      bool alreadyGiven = await AppConfigCache.isLocationPermissionGiven();

      if (!alreadyGiven) {
        // FIRST TIME → ask permission
        LocationPermission permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          loading = false;
          notifyListeners();
          return;
        }

        // Save permission permanently
    //    await AppConfigCache.saveLocationPermissionStatus(true);
      }
      else
        {
          var snackBar = SnackBar(content: Text('Permission Granted! You can start using the app'));
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
        }
      // NEXT TIME → no popup, direct location
      position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      if (isAddress) {
        currentAddress = await _getAddressFromLatLng(position!);
      }

      //await getIpAddress();
    } catch (e) {
      debugPrint("Error: $e");
    }

    loading = false;
    notifyListeners();
  }


  Future<Position> _getCurrentLocation() async {
    // Verify that location services are enabled.
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check and request location permissions.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception(
        'Location permissions are permanently denied, cannot request permissions.',
      );
    }

    // Permissions granted, fetch and return the current position.
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30)
      ),
      /*desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 30),*/
    );
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String address =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      return address;
    } catch (e) {
      return "Failed to get address: $e";
    }
  }

  Future<void> getIpAddress() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('IP fetch timeout'),
          );

      if (response.statusCode == 200) {
        final ipAddress = jsonDecode(response.body)['ip'];
        setIpAddress(ipAddress);

      } else {
        locationError = "Failed to fetch IP address";
      }
    } catch (e) {
      // IP fetch failure is not critical, continue
    }
  }
}

/**
 * Future<void> requestPermissionsAndFetchData() async {
 * 
 * // loading = true;
    //notifyListeners();
    // locationError = null;

    // try {
    //   // Ask location permission
    //   print('[LocationIPProvider] Requesting location permission...');
    //   final locStatus = await Permission.location.request();
    //   print('[LocationIPProvider] Location permission status: $locStatus');

    //   // If the user permanently denied permissions, prompt to open Settings
    //   if (locStatus == PermissionStatus.permanentlyDenied ||
    //       locStatus.isPermanentlyDenied) {
    //     locationError =
    //         "Location permission permanently denied. Please enable location permission in Settings.";
    //     // Attempt to open app settings so user can enable permission
    //     try {
    //       await openAppSettings();
    //     } catch (e) {
    //       print('[LocationIPProvider] Failed to open app settings: $e');
    //     }
    //     loading = false;
    //     notifyListeners();
    //     return;
    //   }

    //   if (!locStatus.isGranted) {
    //     locationError = "Location permission denied. Status: $locStatus";
    //     loading = false;
    //     notifyListeners();
    //     return;
    //   }

    //   // Check GPS
    //   print('[LocationIPProvider] Checking if location services enabled...');
    //   final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //   print('[LocationIPProvider] Location services enabled: $serviceEnabled');

    //   if (!serviceEnabled) {
    //     locationError = "Please enable location services.";
    //     loading = false;
    //     notifyListeners();
    //     return;
    //   }

    //   // Get location
    //   print('[LocationIPProvider] Fetching current position...');
    //   position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high,
    //     timeLimit: const Duration(seconds: 30),
    //   );
    //   print(
    //     '[LocationIPProvider] Position: ${position?.latitude}, ${position?.longitude}',
    //   );

    //   // Get address
    //   print('[LocationIPProvider] Fetching address from coordinates...');
    //   final placemarks = await placemarkFromCoordinates(
    //     position!.latitude,
    //     position!.longitude,
    //   );

    //   if (placemarks.isNotEmpty) {
    //     final place = placemarks.first;
    //     currentAddress =
    //         "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    //     print('[LocationIPProvider] Address: $currentAddress');
    //   } else {
    //     print('[LocationIPProvider] No placemarks found');
    //     currentAddress = "Location coordinates available but address not found";
    //   }

    //   // Get IP
    //   print('[LocationIPProvider] Fetching IP address...');
    //   try {
    //     final response = await http
    //         .get(Uri.parse('https://api.ipify.org?format=json'))
    //         .timeout(
    //           const Duration(seconds: 10),
    //           onTimeout: () => throw Exception('IP fetch timeout'),
    //         );

    //     if (response.statusCode == 200) {
    //       ip = jsonDecode(response.body)['ip'];
    //       print('[LocationIPProvider] IP Address: $ip');
    //     } else {
    //       print(
    //         '[LocationIPProvider] IP fetch failed with status: ${response.statusCode}',
    //       );
    //       locationError = "Failed to fetch IP address";
    //     }
    //   } catch (e) {
    //     print('[LocationIPProvider] IP fetch error: $e');
    //     // IP fetch failure is not critical, continue
    //   }

    //   loading = false;
    //   notifyListeners();
    // } catch (e) {
    //   print('[LocationIPProvider] Error: $e');
    //   locationError = e.toString();
    //   loading = false;
    //   notifyListeners();
    // }
}
 */
