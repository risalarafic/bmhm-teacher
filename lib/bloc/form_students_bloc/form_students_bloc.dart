import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../auth_service/auth_service.dart';
import '../../models/student_attendance.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import '../../utils/constants/app_strings.dart';
import 'form_students_bloc_model.dart';

class FormStudentsBloc {
  FormStudentsBloc({required this.service});

  final BaseService service;
  final StreamController<FormStudentsBlocModel> _modelController =
      StreamController<FormStudentsBlocModel>.broadcast();

  Stream<FormStudentsBlocModel> get modelStream => _modelController.stream;
  FormStudentsBlocModel _model = FormStudentsBlocModel();
  FormStudentsBlocModel get current => _model;

  void dispose() {
    _modelController.close();
  }

  void _updateWith({
    bool? isLoading,
    List<StudentAttendance>? students,
    String? formClass,
    String? error,
    bool clearError = false,
  }) {
    _model = _model.copyWith(
      isLoading: isLoading,
      students: students,
      formClass: formClass,
      error: error,
      clearError: clearError,
    );
    _modelController.add(_model);
  }

  Future<void> load(BuildContext context) async {
    _updateWith(isLoading: true, clearError: true);
    try {
      final user = teacher ?? await getUserInfo();
      final auth = await teacherApiBody();
      final grade = user?.formGrade?.trim() ?? '';
      final section = user?.formSection?.trim() ?? '';
      final formClass = user?.formClass ?? '';
      _updateWith(formClass: formClass);

      if (grade.isEmpty || section.isEmpty) {
        _updateWith(
          isLoading: false,
          students: const [],
          error: 'Form class is not assigned.',
        );
        return;
      }
      if (!context.mounted) return;

      final response = await service.execute(
        context,
        formStudents,
        method: Method.post,
        showLoading: false,
        showSnackBar: false,
        body: {
          'username': auth['username'] ?? user?.email ?? '',
          'auth_token': auth['auth_token'] ?? '',
          'grade': grade,
          'section': section,
          'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
        },
      );

      if (response == null) {
        _updateWith(
          isLoading: false,
          students: const [],
          error: 'Unable to load students. Please try again.',
        );
        return;
      }

      _updateWith(
        isLoading: false,
        students: StudentAttendance.parseFormStudents(response),
        clearError: true,
      );
    } catch (e) {
      debugPrint('formstudents page $e');
      _updateWith(
        isLoading: false,
        students: const [],
        error: 'Unable to load students. Please try again.',
      );
    }
  }
}
