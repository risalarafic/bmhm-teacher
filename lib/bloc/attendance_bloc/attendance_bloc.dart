import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../auth_service/auth_service.dart';
import '../../models/student_attendance.dart';
import '../../models/user.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/colors.dart';
import 'attendance_bloc_model.dart';

class AttendanceBloc {
  AttendanceBloc({required this.service}) {
    _applyTeacher(teacher);
  }

  final BaseService service;
  final StreamController<AttendanceBlocModel> _modelController =
      StreamController<AttendanceBlocModel>.broadcast();

  Stream<AttendanceBlocModel> get modelStream => _modelController.stream;
  AttendanceBlocModel _model = AttendanceBlocModel();
  AttendanceBlocModel get current => _model;
  bool _loadingStudents = false;

  void dispose() {
    _modelController.close();
  }

  Future<void> init(BuildContext context) async {
    final user = teacher ?? await getUserInfo();
    _applyTeacher(user);
    _modelController.add(_model);
    if (!context.mounted) return;
    await loadStudents(context);
  }

  void _applyTeacher(Teacher? user) {
    final grade = user?.formGrade?.trim();
    final section = user?.formSection?.trim();
    if ((grade == null || grade.isEmpty) &&
        (section == null || section.isEmpty)) {
      return;
    }
    _model = _model.copyWith(
      grade: (grade != null && grade.isNotEmpty) ? grade : null,
      section: (section != null && section.isNotEmpty) ? section : null,
    );
  }

  void _updateWith({
    String? grade,
    String? section,
    DateTime? date,
    List<StudentAttendance>? students,
    bool? isSubmitting,
    bool? isLoading,
    bool clearGrade = false,
    bool clearSection = false,
  }) {
    _model = _model.copyWith(
      grade: grade,
      section: section,
      date: date,
      students: students,
      isSubmitting: isSubmitting,
      isLoading: isLoading,
      clearGrade: clearGrade,
      clearSection: clearSection,
    );
    _modelController.add(_model);
  }

  void setStatus(String studentId, AttendanceStatus status) {
    final students = _model.students
        .map((s) => s.id == studentId ? s.copyWith(status: status) : s)
        .toList();
    _updateWith(students: students);
  }

  void markAllPresent() {
    final students = _model.students
        .map((s) => s.copyWith(status: AttendanceStatus.present))
        .toList();
    _updateWith(students: students);
  }

  Future<void> submit(BuildContext context) async {
    if (!_model.hasSelection || _model.students.isEmpty) return;
    _updateWith(isSubmitting: true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _updateWith(isSubmitting: false);
    if (!context.mounted) return;
    showSnackBarMessage(
      'Attendance submitted for ${_model.formClass}',
      context,
      AppColors.primary,
    );
  }

  Future<void> loadStudents(BuildContext context) async {
    if (!_model.hasSelection || _loadingStudents) return;
    _loadingStudents = true;
    _updateWith(isLoading: true);

    try {
      final auth = await teacherApiBody();
      final user = teacher ?? await getUserInfo();
      if (!context.mounted) return;

      final response = await service.execute(
        context,
        formStudents,
        method: Method.post,
        showLoading: false,
        showSnackBar: false,
        body: {
          'username': user?.email ?? auth['username'] ?? '',
          'auth_token': auth['auth_token'] ?? '',
          'grade': _model.grade,
          'section': _model.section,
          'date': apiDate(DateTime.now()),
        },
      );

      final list = StudentAttendance.parseFormStudents(response);
      _updateWith(isLoading: false, students: list);
    } catch (e) {
      debugPrint('formstudents $e');
      _updateWith(isLoading: false, students: const []);
    } finally {
      _loadingStudents = false;
    }
  }

  String formatDate(DateTime date) => DateFormat('d MMM yyyy').format(date);

  String apiDate(DateTime date) => DateFormat('dd-MM-yyyy').format(date);
}
