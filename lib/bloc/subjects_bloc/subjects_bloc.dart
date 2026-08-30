import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth_service/auth_service.dart';
import '../../models/teacher_subject.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import '../../utils/constants/app_strings.dart';
import 'subjects_bloc_model.dart';

class SubjectsBloc {
  SubjectsBloc({required this.service});

  final BaseService service;
  final StreamController<SubjectsBlocModel> _modelController =
      StreamController<SubjectsBlocModel>();

  Stream<SubjectsBlocModel> get modelStream => _modelController.stream;
  SubjectsBlocModel _model = SubjectsBlocModel();
  SubjectsBlocModel get current => _model;

  void dispose() {
    _modelController.close();
  }

  void _updateWith({
    bool? isLoading,
    List<TeacherSubject>? subjects,
    String? error,
    bool clearError = false,
  }) {
    _model = _model.copyWith(
      isLoading: isLoading,
      subjects: subjects,
      error: error,
      clearError: clearError,
    );
    _modelController.add(_model);
  }

  Future<void> load(BuildContext context) async {
    _updateWith(isLoading: true, clearError: true);
    try {
      final body = await teacherApiBody();
      debugPrint('teachersubjects body $body');
      if (!context.mounted) return;
      final response = await service.execute(
        context,
        teacherSubjects,
        method: Method.post,
        showLoading: false,
        showSnackBar: false,
        body: body,
      );
      if (response == null) {
        _updateWith(
          isLoading: false,
          subjects: const [],
          error: 'Unable to load subjects. Please try again.',
        );
        return;
      }
      final list = TeacherSubject.parseResponse(response);
      _updateWith(isLoading: false, subjects: list, clearError: true);
    } catch (e) {
      debugPrint('teachersubjects $e');
      _updateWith(
        isLoading: false,
        subjects: const [],
        error: 'Unable to load subjects. Please try again.',
      );
    }
  }
}
