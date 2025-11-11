import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/core/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../main.dart';
import '../routes/app_routes.dart';
import 'gloable_status_code.dart';

/// HTTP methods enum (lint ignored because uppercase is fine for HTTP)

enum HttpMethod { get, post, put, patch, delete }

Future callApi({
  required String url,
  HttpMethod method = HttpMethod.get,
  Map<String, dynamic>? body,
  Map<String, String>? headers,
  Map<String, dynamic>? queryParams,
  Duration timeout = const Duration(seconds: 30),
}) async {
  try {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    debugPrint('====R{$url');
    final requestHeaders = headers ?? await ApiConfig.getCommonHeaders();

    late http.Response response;

    switch (method) {
      case HttpMethod.get:
        response = await http
            .get(uri, headers: requestHeaders)
            .timeout(timeout);
        break;
      case HttpMethod.post:
        response = await http
            .post(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.put:
        response = await http
            .put(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.patch:
        response = await http
            .patch(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.delete:
        if (body != null) {
          final request = http.Request("DELETE", uri);
          request.headers.addAll(requestHeaders);
          request.body = jsonEncode(body);
          final streamedResponse = await request.send().timeout(timeout);
          response = await http.Response.fromStream(streamedResponse);
        } else {
          response = await http
              .delete(uri, headers: requestHeaders)
              .timeout(timeout);
        }
        break;
    }

    return getResponse(response);
  } on SocketException {
    errorMessage =
        "No Internet connection. Please check your network and try again.";
    return {'status': false, 'message': errorMessage};
  } on TimeoutException {
    errorMessage = "Request timed out. Please try again later.";

    return {'status': false, 'message': errorMessage};
  } catch (e) {
    debugPrint('====R{$e');
    errorMessage = "Something went wrong. Please try again.";
    return {'status': false, 'message': errorMessage};
  }
}

bool _isRedirectingToLogin = false;

Future<String> getResponse(Response response) async {
  globalStatusCode = response.statusCode;

  Map<String, dynamic> parsedJson = {};
  try {
    parsedJson = jsonDecode(response.body.toString());
  } catch (e) {
    // Not JSON
  }

  if (parsedJson['response'] == 'token error' &&
      parsedJson['data']?['message']?.toString() == 'Token Expired') {
    errorMessage =
        parsedJson['data']?['message'] ?? 'Session expired, please login again';
    debugPrint('Error: $errorMessage');

    if (!_isRedirectingToLogin) {
      _isRedirectingToLogin = true;
      Future.microtask(() {
        final context = navigatorKey.currentContext;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Session expired, please login again.',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
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

    return "{\"status\":\"false\",\"message\":\"$errorMessage\"}";
  }
  // Handle HTTP status codes
  switch (globalStatusCode) {
    case 401:
      errorMessage = parsedJson['message']?.toString() ?? 'Unauthorized';
      if (!_isRedirectingToLogin) {
        _isRedirectingToLogin = true;
        Future.microtask(() {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.loginScreen,
            (route) => false,
          );
        });
      }
      return "{\"status\":\"false\",\"message\":\"$errorMessage\"}";

    case 400:
    case 422:
      errorMessage = parsedJson['message']?.toString() ?? 'Invalid request';
      return "{\"status\":\"false\",\"message\":\"${errorMessage?.replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";

    case 403:
      errorMessage = parsedJson['message']?.toString() ?? 'Forbidden';
      return "{\"status\":\"false\",\"message\":\"$errorMessage\"}";

    case 404:
      errorMessage = parsedJson['message']?.toString() ?? 'Not Found';
      return "{\"status\":\"419\",\"message\":\"${errorMessage?.replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";

    case 405:
      errorMessage = 'This Method not allowed.';
      return "{\"status\":\"0\",\"message\":\"$errorMessage\"}";

    case 419:
      errorMessage = parsedJson['message']?.toString() ?? 'Session expired';
      return "{\"status\":\"false\",\"message\":\"${errorMessage?.replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";

    case 500:
    case 502:
    case 503:
      errorMessage =
          parsedJson['message']?.toString() ?? 'Internal server issue';
      return "{\"status\":\"false\",\"message\":\"Internal server issue\"}";

    case 204:
      errorMessage = parsedJson['message']?.toString() ?? 'No content';
      return "{\"status\":\"false\",\"message\":\"${errorMessage?.replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";

    default:
      return response.body;
  }
}
