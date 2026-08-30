import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth_service/auth_service.dart';
import '../../models/class_routine.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import '../../utils/constants/app_strings.dart';
import 'routine_bloc_model.dart';

class RoutineBloc {
  RoutineBloc({required this.service});

  final BaseService service;
  final StreamController<RoutineBlocModel> _modelController =
      StreamController<RoutineBlocModel>();

  Stream<RoutineBlocModel> get modelStream => _modelController.stream;
  RoutineBlocModel _model = RoutineBlocModel(
    selectedWeekday: ClassRoutine.selectedWeekdayFor(DateTime.now()),
  );
  RoutineBlocModel get current => _model;

  void dispose() {
    _modelController.close();
  }

  void _updateWith({
    bool? isLoading,
    ClassRoutine? routine,
    int? selectedWeekday,
    String? error,
    bool clearError = false,
  }) {
    _model = _model.copyWith(
      isLoading: isLoading,
      routine: routine,
      selectedWeekday: selectedWeekday,
      error: error,
      clearError: clearError,
    );
    _modelController.add(_model);
  }

  void selectWeekday(int weekday) => _updateWith(selectedWeekday: weekday);

  Future<void> load(BuildContext context) async {
    _updateWith(isLoading: true, clearError: true);
    try {
      final creds = await teacherApiBody();
      final body = {
        'username': creds['username'],
        'auth_token': creds['auth_token'],
        'shift': creds['shift'],
      };
      if (!context.mounted) return;
      final response = await service.execute(
        context,
        teacherRoutine,
        method: Method.post,
        showLoading: false,
        showSnackBar: false,
        body: body,
      );
      if (response is Map<String, dynamic> &&
          (response['success'] == true ||
              response['success'] == 1 ||
              response['success']?.toString() == 'true')) {
        final routine = ClassRoutine.fromJson(response);
        _updateWith(isLoading: false, routine: routine, clearError: true);
        return;
      }
      _updateWith(
        isLoading: false,
        routine: const ClassRoutine(slots: []),
        error: 'Unable to load class routine. Please try again.',
      );
    } catch (e) {
      debugPrint('teacherroutine page $e');
      _updateWith(
        isLoading: false,
        routine: const ClassRoutine(slots: []),
        error: 'Unable to load class routine. Please try again.',
      );
    }
  }
}
