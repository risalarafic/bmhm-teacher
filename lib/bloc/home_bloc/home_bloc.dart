import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth_service/auth_service.dart';
import '../../models/home.dart';
import '../../models/user.dart';
import '../../screens/login_page.dart';
import '../../screens/attendance_page.dart';
import '../../screens/form_students_page.dart';
import '../../screens/subjects_page.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/colors.dart';
import 'home_bloc_model.dart';

class HomeBloc {
  HomeBloc({required this.service}) {
    _applyUser(teacher);
  }

  final BaseService service;
  final StreamController<HomeBlocModel> _modelController =
      StreamController<HomeBlocModel>();

  Stream<HomeBlocModel> get modelStream => _modelController.stream;
  HomeBlocModel _model = HomeBlocModel();
  HomeBlocModel get currentModel => _model;

  void dispose() {
    _modelController.close();
  }

  void _updateWith({
    bool? isLoading,
    int? navigationIndex,
    Home? home,
    String? teacherName,
    String? teacherRole,
    String? teacherEmail,
    String? teacherId,
    String? formClass,
    String? teacherImage,
  }) {
    _model = _model.copyWith(
      isLoading: isLoading,
      navigationIndex: navigationIndex,
      home: home,
      teacherName: teacherName,
      teacherRole: teacherRole,
      teacherEmail: teacherEmail,
      teacherId: teacherId,
      formClass: formClass,
      teacherImage: teacherImage,
    );
    _modelController.add(_model);
  }

  void _applyUser(Teacher? user) {
    if (user == null) return;
    _model = _model.copyWith(
      isLoading: false,
      teacherName: user.name?.isNotEmpty == true ? user.name : _model.teacherName,
      teacherRole: user.role?.isNotEmpty == true ? user.role : 'Teacher',
      teacherEmail: user.email,
      teacherId: user.displayId?.toString() ?? _model.teacherId,
      formClass: user.formClass.isNotEmpty ? user.formClass : _model.formClass,
      teacherImage: user.image,
    );
  }

  Future<void> init(BuildContext context) async {
    final user = teacher ?? await getUserInfo();
    _applyUser(user);
    _updateWith(
      isLoading: false,
      home: Home(
        title: 'Dashboard',
        subtitle: 'Welcome to BMHM Teacher',
      ),
    );
    if (!context.mounted) return;
    await loadHome(context);
  }

  Future<void> loadHome(BuildContext context) async {
    try {
      final response = await service.execute(
        context,
        home,
        showLoading: false,
        showSnackBar: false,
      );
      if (response is Map<String, dynamic>) {
        _updateWith(home: Home.fromJson(response), isLoading: false);
      }
    } catch (e) {
      debugPrint('home api $e');
      _updateWith(isLoading: false);
    }
  }

  void updateNavIndex(int index) => _updateWith(navigationIndex: index);

  void onMenuTap(BuildContext context, String id) {
    if (id == 'form_attendance') {
      open(context, AttendancePage.create(context, showBack: true));
      return;
    }
    if (id == 'subjects') {
      open(context, SubjectsPage.create(context));
      return;
    }
    if (id == 'form_students') {
      open(context, FormStudentsPage.create(context));
      return;
    }
    showSnackBarMessage('$id coming soon', context, AppColors.primary);
  }

  void onReminderTap(BuildContext context) {
    showSnackBarMessage('Class routine coming soon', context, AppColors.primary);
  }

  void onNotificationsTap(BuildContext context) {
    showSnackBarMessage('Notifications coming soon', context, AppColors.primary);
  }

  Future<void> logout(BuildContext context) async {
    await clearPrefs();
    if (!context.mounted) return;
    openAsNewPage(context, LoginPage.create(context));
  }
}
