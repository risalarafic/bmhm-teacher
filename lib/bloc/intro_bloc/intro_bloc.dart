import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth_service/auth_service.dart';
import '../../screens/login_page.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import 'intro_bloc_model.dart';

class IntroBloc {
  IntroBloc({required this.service});

  final BaseService service;
  final StreamController<IntroBlocModel> _modelController =
      StreamController<IntroBlocModel>();

  Stream<IntroBlocModel> get modelStream => _modelController.stream;
  IntroBlocModel _model = IntroBlocModel();

  void dispose() {
    _modelController.close();
  }

  void updatePageIndex(int index) {
    _model = _model.copyWith(pageIndex: index);
    _modelController.add(_model);
  }

  Future<void> finish(BuildContext context) async {
    await saveIntro('seen');
    if (!context.mounted) return;
    openAsNewPage(context, LoginPage.create(context));
  }
}
