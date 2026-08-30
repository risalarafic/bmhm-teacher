import 'package:flutter/material.dart';

import '../../utils/common_methods.dart';
import '../../utils/constants/colors.dart';
import '../app_text/app_texts.dart';

Future<bool?> appAlertDialog(
  BuildContext context,
  String message, {
  String? actionButtonTitle,
  String? title,
  String? cancelButtonTitle,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: AppText(title ?? 'Message', size: 16, textType: TextWeight.bold),
      content: AppText(message),
      actions: [
        if (cancelButtonTitle != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: AppText(cancelButtonTitle, color: AppColors.grey),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: AppText(actionButtonTitle ?? 'OK', color: AppColors.primary),
        ),
      ],
    ),
  );
}
