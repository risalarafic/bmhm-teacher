import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user.dart';

Teacher? teacher;
String? kToken;

enum Method { get, post, delete, update }

enum TextWeight { light, regular, medium, bold }

String get deviceType => Platform.isIOS ? 'ios' : 'android';

void open(BuildContext context, Widget targetPage) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => targetPage),
  );
}

void openAsNewPage(BuildContext context, Widget targetPage) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => targetPage),
    (route) => false,
  );
}

void closePage(BuildContext context) => Navigator.of(context).pop();

bool _isLoaderShowing = false;

void showLoaderDialog(BuildContext context) {
  if (_isLoaderShowing || !context.mounted) return;
  _isLoaderShowing = true;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    ),
  ).whenComplete(() {
    _isLoaderShowing = false;
  });
}

void hideLoader(BuildContext context) {
  if (!_isLoaderShowing) return;
  final navigator = Navigator.of(context, rootNavigator: true);
  if (navigator.canPop()) navigator.pop();
}

void showSnackBarMessage(String content, BuildContext context, Color color) {
  if (content.isEmpty) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        content,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

FontWeight getFontWeight(TextWeight textType) {
  switch (textType) {
    case TextWeight.light:
      return FontWeight.w300;
    case TextWeight.regular:
      return FontWeight.w500;
    case TextWeight.medium:
      return FontWeight.w700;
    case TextWeight.bold:
      return FontWeight.w900;
  }
}
