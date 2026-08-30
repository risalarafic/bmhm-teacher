import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth_service/auth_service.dart';
import '../../models/user.dart';
import '../../screens/home_page.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/colors.dart';
import 'login_bloc_model.dart';

class LoginBloc {
  LoginBloc({required this.service});

  final BaseService service;
  final StreamController<LoginBlocModel> _modelController =
      StreamController<LoginBlocModel>();

  Stream<LoginBlocModel> get modelStream => _modelController.stream;
  LoginBlocModel _model = LoginBlocModel();

  void dispose() {
    _modelController.close();
  }

  void _updateWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? obscurePassword,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      isLoading: isLoading,
      obscurePassword: obscurePassword,
    );
    _modelController.add(_model);
  }

  void updateEmail(String? email) => _updateWith(email: email);
  void updatePassword(String? password) => _updateWith(password: password);
  void toggleObscure() => _updateWith(obscurePassword: !_model.obscurePassword);

  Future<void> login(BuildContext context) async {
    final email = _model.email.trim();
    final password = _model.password;
    if (email.isEmpty || password.isEmpty) {
      showSnackBarMessage(
        'Please enter your credentials.',
        context,
        AppColors.red,
      );
      return;
    }

    _updateWith(isLoading: true);
    try {
      final response = await service.execute(
        context,
        signIn,
        method: Method.post,
        showLoading: false,
        body: {
          'username': email,
          'password': password,
        },
      );
      if (response == null) return;
      if (response is! Map<String, dynamic>) {
        if (context.mounted) {
          showSnackBarMessage('Unable to sign in. Please try again.', context, AppColors.red);
        }
        return;
      }

      final success = response['success'] == true ||
          response['success'] == 1 ||
          response['success']?.toString() == 'true';
      if (!success) {
        if (context.mounted) {
          showSnackBarMessage(
            response['message']?.toString() ?? 'Login failed.',
            context,
            AppColors.red,
          );
        }
        return;
      }

      final token = (response['auth_token'] ?? response['token'])?.toString();
      final details = response['userdtls'] ?? response['user'];
      final detailsMap =
          details is Map ? Map<String, dynamic>.from(details) : <String, dynamic>{};
      final apiUsername = detailsMap['email']?.toString() ?? email;
      final userMap = <String, dynamic>{
        ...detailsMap,
        'username': apiUsername,
        'token': token,
        'auth_token': token,
        'role': 'Teacher',
      };
      final user = Teacher.fromJson(userMap);
      await saveUserInfo(user);
      if (!context.mounted) return;
      openAsNewPage(context, HomePage.create(context));
    } catch (e) {
      if (context.mounted) {
        showSnackBarMessage(e.toString(), context, AppColors.red);
      }
    } finally {
      _updateWith(isLoading: false);
    }
  }
}
