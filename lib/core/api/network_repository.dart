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

enum HttpMethod { GET, POST, PUT, PATCH, DELETE }

Future callApi({
  required String url,
  HttpMethod method = HttpMethod.GET,
  Map<String, dynamic>? body,
  Map<String, String>? headers,
  Map<String, String>? queryParams,
  Duration timeout = const Duration(seconds: 30),
}) async {
  try {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    print('====R{$url');
    final requestHeaders = headers ?? await ApiConfig.getCommonHeaders();

    late http.Response response;

    switch (method) {
      case HttpMethod.GET:
        response = await http
            .get(uri, headers: requestHeaders)
            .timeout(timeout);
        break;
      case HttpMethod.POST:
        response = await http
            .post(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.PUT:
        response = await http
            .put(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.PATCH:
        response = await http
            .patch(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.DELETE:
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
    //_showErrorDialog(errorMessage ?? '');
    return {'status': false, 'message': errorMessage};
  } on TimeoutException {
    errorMessage = "Request timed out. Please try again later.";
    //_showErrorDialog(errorMessage ?? '');
    return {'status': false, 'message': errorMessage};
  } catch (e) {

    print('====R{$e');
    errorMessage = "Something went wrong. Please try again.";
    //_showErrorDialog(errorMessage ?? '');
    return {'status': false, 'message': errorMessage};
  }
}

Future getResponse(Response response) async {
  globalStatusCode = response.statusCode;

  if (globalStatusCode == 500 ||
      globalStatusCode == 502 ||
      globalStatusCode == 503) {
    print('${response.body.toString()}');
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"false\",\"message\":\"Internal server issue\"}";
  } else if (globalStatusCode == 401) {
    final parsedJson = jsonDecode(response.body.toString());
    final message = parsedJson['message'].toString();
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"false\",\"message\":\"$message\"}";
  } else if (globalStatusCode == 403) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"false\",\"message\":\"Internal server issue\"}";
  } else if (globalStatusCode == 405) {
    //assolyr
    String error = "This Method not allowed.";

    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"0\",\"message\":\"$error\"}";
  }


  else if (globalStatusCode == 401) {
    try {


      // redirect to login page after unauthorized
      Future.microtask(() {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.loginScreen,
              (route) => false,
        );
      });

      return "{\"status\":\"false\",\"message\":\"Error\"}";
    } catch (e) {
      return "{\"status\":\"false\",\"message\":\"Unauthorized access\"}";
    }
  }
  else if (globalStatusCode == 400) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return response.body;
  } else if (globalStatusCode == 404) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"419\",\"message\":\"${errorMessage.toString().replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";
    //return response.body;
  } else if (globalStatusCode == 419) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"false\",\"message\":\"${errorMessage.toString().replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";
    //return response.body;
  } else if (globalStatusCode == 422) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();
    final message = parsedJson['message'].toString();
    return "{\"status\":\"false\",\"message\":\"${message.replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";
  } else if (globalStatusCode == 204) {
    final parsedJson = jsonDecode(response.body.toString());
    final message = parsedJson['message'].toString();
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"false\",\"message\":\"${message.replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";
  } else if (globalStatusCode < 200 || globalStatusCode > 404) {
    String error = response.headers['message'].toString();

    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"0\",\"message\":\"$error\"}";
  }
  return response.body;
}

void _showErrorDialog(String message) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
