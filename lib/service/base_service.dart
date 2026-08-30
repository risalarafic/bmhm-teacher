import 'package:flutter/material.dart';

import '../utils/common_methods.dart';

abstract class BaseService {
  Future<dynamic> execute(
    BuildContext context,
    String endPoint, {
    Method method = Method.get,
    Map<String, dynamic>? body,
    bool showLoading = true,
    bool isSetting = false,
    bool showSnackBar = true,
  });

  Future<dynamic> executeMultiPart(
    BuildContext context,
    String endPoint, {
    Map<String, String>? body,
  });
}
