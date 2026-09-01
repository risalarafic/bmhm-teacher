import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../auth_service/auth_service.dart';
import '../configuration/configuration.dart';
import '../screens/login_page.dart';
import '../utils/common_methods.dart';
import '../utils/constants/colors.dart';
import 'base_service.dart';

class APIService implements BaseService {
  String get baseUrl => AppConfig.baseUrl;

  Future<Map<String, String>> headers() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final header = <String, String>{
      'Accept': 'application/json',
      'Accept-Language': 'en',
      'Content-Type': 'application/json',
      'AppToken': 'Bearer ${AppConfig.appToken}',
      'DeviceType': deviceType,
      'AppVersion': packageInfo.version,
      'Connection': 'keep-alive',
    };
    final userToken = teacher?.token ?? kToken;
    if (userToken != null && userToken.isNotEmpty) {
      header['Authorization'] = 'Bearer $userToken';
    }
    return header;
  }

  @override
  Future<dynamic> execute(
    BuildContext context,
    String endPoint, {
    Method method = Method.get,
    Map<String, dynamic>? body,
    bool showLoading = true,
    bool isSetting = false,
    bool showSnackBar = true,
  }) async {
    if (showLoading) showLoaderDialog(context);
    final header = await headers();
    final url = Uri.parse('$baseUrl$endPoint');
    debugPrint('url $url body $body method $method');

    try {
      final http.Response response;
      switch (method) {
        case Method.get:
          response = await http.get(url, headers: header);
          break;
        case Method.post:
          response = await http.post(
            url,
            body: jsonEncode(body),
            headers: header,
          );
          break;
        case Method.delete:
          response = await http.delete(
            url,
            body: jsonEncode(body),
            headers: header,
          );
          break;
        case Method.update:
          response = await http.put(
            url,
            body: jsonEncode(body),
            headers: header,
          );
          break;
      }
      debugPrint('response status ${response.statusCode}');
      debugPrint(response.body, wrapWidth: 800);
      if (!context.mounted) return null;
      return _returnResponse(
        response,
        context,
        method,
        showSnackBar,
      );
    } catch (e) {
      debugPrint('error $e');
      if (context.mounted && showSnackBar) {
        showSnackBarMessage(
          e.toString().replaceFirst('Exception: ', ''),
          context,
          AppColors.red,
        );
      }
      return null;
    } finally {
      if (showLoading && context.mounted) hideLoader(context);
    }
  }

  dynamic _returnResponse(
    http.Response response,
    BuildContext context,
    Method method,
    bool showSnackBar,
  ) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return _responseBody(response.body, context, method, showSnackBar);
      case 401:
        clearPrefs();
        if (context.mounted) {
          openAsNewPage(context, LoginPage.create(context));
        }
        return null;
      default:
        _handleError(response.body, context, showSnackBar, response.statusCode);
        return null;
    }
  }

  dynamic _responseBody(
    String body,
    BuildContext context,
    Method method,
    bool showSnackBar,
  ) {
    final responseJson = jsonDecode(body);
    if (responseJson is! Map<String, dynamic>) return responseJson;

    final hasError = responseJson['error'] == true ||
        responseJson['success'] == false;
    final message = responseJson['message']?.toString() ?? '';
    final data = responseJson['data'] ?? responseJson;

    if (hasError) {
      if (showSnackBar && context.mounted) {
        showSnackBarMessage(message, context, AppColors.red);
      }
      return null;
    }

    if (showSnackBar && message.isNotEmpty && method != Method.get) {
      showSnackBarMessage(message, context, AppColors.green);
    }
    return data;
  }

  void _handleError(
    String body,
    BuildContext context,
    bool showSnackBar,
    int statusCode,
  ) {
    var message = statusCode == 404
        ? 'Unable to sign in right now. Please try again later.'
        : 'Something went wrong';
    try {
      final responseJson = jsonDecode(body);
      if (responseJson is Map && responseJson['message'] != null) {
        message = responseJson['message'].toString();
      }
    } catch (_) {}
    if (showSnackBar && context.mounted) {
      showSnackBarMessage(message, context, AppColors.red);
    }
  }

  @override
  Future<dynamic> executeMultiPart(
    BuildContext context,
    String endPoint, {
    Map<String, String>? body,
  }) async {
    showLoaderDialog(context);
    final header = await headers();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endPoint'),
    );
    request.headers.addAll(header);
    if (body != null) request.fields.addAll(body);

    try {
      final response = await request.send();
      if (response.statusCode == HttpStatus.ok) return true;
      final respStr = await response.stream.bytesToString();
      if (!context.mounted) return null;
      _handleError(respStr, context, true, response.statusCode);
      return null;
    } catch (e) {
      debugPrint('ERROR $e');
      return null;
    } finally {
      if (context.mounted) hideLoader(context);
    }
  }
}
