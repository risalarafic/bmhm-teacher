import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth_service/auth_service.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import 'splash_bloc_model.dart';

class SplashBloc {
  SplashBloc({
    required this.service,
  });

  final BaseService service;
  final StreamController<SplashBlocModel> _modelController =
      StreamController<SplashBlocModel>();

  Stream<SplashBlocModel> get modelStream => _modelController.stream;
  SplashBlocModel _model = SplashBlocModel();

  SplashNavigationOption get navigationOption => _model.navigationOption;

  void dispose() {
    _modelController.close();
  }

  void _updateWith({SplashNavigationOption? navigationOption}) {
    _model = _model.copyWith(navigationOption: navigationOption);
    _modelController.add(_model);
  }

  Future<void> init(BuildContext context) async {
    teacher = await getUserInfo();
    if (teacher != null) {
      _updateWith(navigationOption: SplashNavigationOption.home);
      return;
    }

    final intro = await getIntro();
    _updateWith(
      navigationOption: intro == null
          ? SplashNavigationOption.intro
          : SplashNavigationOption.signInOption,
    );
  }
}
