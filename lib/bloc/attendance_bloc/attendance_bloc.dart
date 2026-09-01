import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth_service/auth_service.dart';
import '../../models/student_attendance.dart';
import '../../models/user.dart';
import '../../service/base_service.dart';
import '../../utils/common_methods.dart';
import '../../utils/constants/app_strings.dart';
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

  String get _submittedPrefKey {
    final day = DateFormat('yyyy-MM-dd').format(_model.date);
    final user = teacher?.email ?? teacher?.username ?? '';
    return '$attendanceSubmittedPrefix${user}_${day}_${_model.grade ?? ''}_${_model.section ?? ''}';
  }

  String get _legacySubmittedPrefKey {
    final day = DateFormat('yyyy-MM-dd').format(_model.date);
    return '$attendanceSubmittedPrefix${day}_${_model.grade ?? ''}_${_model.section ?? ''}';
  }

  Future<void> _persistSubmitted(List<StudentAttendance> students) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _submittedPrefKey,
      jsonEncode([
        for (final student in students)
          {
            'student_id': '${student.stdId ?? student.id}',
            'name': student.name,
            'status': student.status.apiCode,
            'guardian_number': student.guardianNumber ?? '',
          },
      ]),
    );
  }

  Future<List<StudentAttendance>?> _restoreSubmitted(
    List<StudentAttendance> existing,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_submittedPrefKey) ??
        prefs.getString(_legacySubmittedPrefKey);
    if (raw == null || raw.isEmpty) return null;
    return StudentAttendance.parseSavedAttendance(
      jsonDecode(raw),
      existing: existing,
    );
  }

  void dispose() {
    _modelController.close();
  }

  Future<void> init(BuildContext context) async {
    final user = teacher ?? await getUserInfo();
    _applyTeacher(user);
    _modelController.add(_model);
    if (!context.mounted) return;
    if (_model.isSubmitted) return;
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
    bool? isSubmitted,
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
      isSubmitted: isSubmitted,
      clearGrade: clearGrade,
      clearSection: clearSection,
    );
    _modelController.add(_model);
  }

  void setStatus(String studentId, AttendanceStatus status) {
    if (_model.isSubmitted) return;
    final students = _model.students
        .map((s) => s.id == studentId ? s.copyWith(status: status) : s)
        .toList();
    _updateWith(students: students);
  }

  void markAllPresent() {
    if (_model.isSubmitted) return;
    final students = _model.students
        .map((s) => s.copyWith(status: AttendanceStatus.present))
        .toList();
    _updateWith(students: students);
  }

  Future<void> submit(BuildContext context) async {
    if (!_model.hasSelection || _model.students.isEmpty || _model.isSubmitted) {
      return;
    }
    _updateWith(isSubmitting: true);

    try {
      final auth = await teacherApiBody();
      final user = teacher ?? await getUserInfo();
      if (!context.mounted) return;

      final body = {
        'username': user?.email ?? auth['username'] ?? '',
        'auth_token': auth['auth_token'] ?? '',
        'attdate': DateFormat('yyyy-MM-dd').format(_model.date),
        'grade': _model.grade,
        'section': _model.section,
        'students': [
          for (final student in _model.students)
            {
              'student_id': '${student.stdId ?? student.id}',
              'status': student.status.apiCode,
              'guardian_number': student.guardianNumber ?? '',
            },
        ],
      };
      debugPrint('saveattendance request $saveAttendance');
      debugPrint('$body', wrapWidth: 800);

      final response = await service.execute(
        context,
        saveAttendance,
        method: Method.post,
        showLoading: false,
        body: body,
      );
      debugPrint('saveattendance response type=${response.runtimeType}');
      debugPrint('$response', wrapWidth: 800);

      if (!context.mounted) return;
      if (response == null) {
        _updateWith(isSubmitting: false);
        return;
      }
      final saved = StudentAttendance.parseSavedAttendance(
        response,
        existing: _model.students,
      );
      debugPrint(
        'saveattendance display ${saved.map((s) => '${s.name}:${s.status.apiCode}').toList()}',
      );
      _updateWith(
        isSubmitting: false,
        isSubmitted: true,
        students: saved.isNotEmpty ? saved : _model.students,
      );
      await _persistSubmitted(saved.isNotEmpty ? saved : _model.students);
    } catch (e) {
      debugPrint('saveattendance $e');
      _updateWith(isSubmitting: false);
    }
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
      final restored = await _restoreSubmitted(list);
      final alreadySubmitted = restored != null && restored.isNotEmpty;
      _updateWith(
        isLoading: false,
        students: alreadySubmitted ? restored : list,
        isSubmitted: alreadySubmitted,
      );
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
