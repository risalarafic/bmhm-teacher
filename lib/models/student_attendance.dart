import 'package:flutter/foundation.dart';

enum AttendanceStatus { present, absent }

extension AttendanceStatusApi on AttendanceStatus {
  String get apiCode => switch (this) {
        AttendanceStatus.present => 'P',
        AttendanceStatus.absent => 'A',
      };
}

class StudentAttendance {
  const StudentAttendance({
    required this.id,
    required this.roll,
    required this.name,
    this.stdId,
    this.guardianNumber,
    this.status = AttendanceStatus.present,
  });

  final String id;
  final int roll;
  final String name;
  final int? stdId;
  final String? guardianNumber;
  final AttendanceStatus status;

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value');
  }

  static String? _parseString(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return text;
  }

  static Map<String, dynamic> _normalized(Map<String, dynamic> json) {
    return {
      for (final entry in json.entries)
        entry.key.toLowerCase().replaceAll(RegExp(r'[\s_-]'), ''): entry.value,
    };
  }

  static dynamic _lookup(Map<String, dynamic> json, List<String> keys) {
    final normalized = _normalized(json);
    for (final key in keys) {
      final match = json[key] ??
          json[key.toLowerCase()] ??
          normalized[key.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '')];
      if (match != null) return match;
    }
    return null;
  }

  static String? _guardianPhone(Map<String, dynamic> json) {
    final nested = json['guardian'] ??
        json['Guardian'] ??
        json['gaurdian'] ??
        json['Gaurdian'] ??
        json['parent'] ??
        json['Parent'] ??
        json['father'] ??
        json['Father'];
    if (nested is Map) {
      final nestedPhone = _guardianPhone(Map<String, dynamic>.from(nested));
      if (nestedPhone != null) return nestedPhone;
    } else {
      final nestedPhone = _parseString(nested);
      if (nestedPhone != null) return nestedPhone;
    }

    final byKey = _parseString(
      _lookup(json, const [
        'guardian_phone',
        'gaurdian_phone',
        'guardianphone',
        'gaurdianphone',
        'guardian_number',
        'gaurdian_number',
        'guardiannumber',
        'gphone',
        'g_phone',
        'gphn',
        'parent_phone',
        'parentphone',
        'parent_mobile',
        'parentmobile',
        'father_phone',
        'fatherphone',
        'fathermobile',
        'father_mobile',
        'fathermob',
        'fmobile',
        'mother_phone',
        'mothermobile',
        'mothermob',
        'mmobile',
        'phone_no',
        'phoneno',
        'phone',
        'mobile_no',
        'mobileno',
        'mobile',
        'contact_no',
        'contactno',
        'sms_number',
        'smsno',
        'sms',
        'tel',
        'telephone',
      ]),
    );
    if (byKey != null) return byKey;

    for (final entry in json.entries) {
      final key = entry.key.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
      final looksLikePhone = key.contains('gphone') ||
          key.contains('gaurdian') ||
          key.contains('guardian') ||
          key.contains('phoneno') ||
          key.contains('mobileno') ||
          ((key.contains('parent') ||
                  key.contains('father') ||
                  key.contains('mother') ||
                  key.contains('sms') ||
                  key.contains('phone') ||
                  key.contains('mobile') ||
                  key.contains('tel')) &&
              !key.contains('name') &&
              !key.contains('email'));
      if (!looksLikePhone) continue;
      if (entry.value is Map) {
        final nestedPhone =
            _guardianPhone(Map<String, dynamic>.from(entry.value as Map));
        if (nestedPhone != null) return nestedPhone;
        continue;
      }
      final value = _parseString(entry.value);
      if (value != null) return value;
    }
    return null;
  }

  factory StudentAttendance.fromJson(Map<String, dynamic> json, int index) {
    return StudentAttendance(
      id: _parseString(
            _lookup(json, const ['student_id', 'stdid', 'std_id', 'id']),
          ) ??
          '$index',
      stdId: _parseInt(
        _lookup(json, const ['student_id', 'stdid', 'std_id', 'id']),
      ),
      roll: index + 1,
      name: _parseString(
            _lookup(json, const ['name', 'student_name', 'stdname']),
          ) ??
          '',
      guardianNumber: _guardianPhone(json),
      status: statusFrom(json) ?? AttendanceStatus.present,
    );
  }

  static AttendanceStatus? statusFrom(dynamic value) {
    if (value is Map) {
      return statusFrom(
        _lookup(Map<String, dynamic>.from(value), const [
          'status',
          'attendance',
          'attstatus',
          'att_status',
          'present',
        ]),
      );
    }
    final text = value?.toString().trim().toUpperCase() ?? '';
    if (text == 'P' ||
        text == 'PRESENT' ||
        text == '1' ||
        text == 'TRUE' ||
        text == 'YES') {
      return AttendanceStatus.present;
    }
    if (text == 'A' ||
        text == 'ABSENT' ||
        text == '0' ||
        text == 'FALSE' ||
        text == 'NO') {
      return AttendanceStatus.absent;
    }
    return null;
  }

  StudentAttendance copyWith({
    String? id,
    int? roll,
    String? name,
    int? stdId,
    String? guardianNumber,
    AttendanceStatus? status,
  }) {
    return StudentAttendance(
      id: id ?? this.id,
      roll: roll ?? this.roll,
      name: name ?? this.name,
      stdId: stdId ?? this.stdId,
      guardianNumber: guardianNumber ?? this.guardianNumber,
      status: status ?? this.status,
    );
  }

  static List<dynamic> _studentList(dynamic response) {
    if (response is List) return response;
    if (response is! Map) return const [];
    dynamic value = response['formstudents'] ??
        response['form_students'] ??
        response['students'] ??
        response['attendance'] ??
        response['data'];
    if (value is! List) {
      for (final entry in response.entries) {
        if (entry.value is List) {
          value = entry.value;
          break;
        }
      }
    }
    return value is List ? value : const [];
  }

  static List<StudentAttendance> parseFormStudents(dynamic response) {
    final raw = _studentList(response);
    if (raw.isNotEmpty && raw.first is Map) {
      debugPrint('formstudents first ${raw.first}');
    }

    return [
      for (var i = 0; i < raw.length; i++)
        if (raw[i] is Map)
          StudentAttendance.fromJson(
            Map<String, dynamic>.from(raw[i] as Map),
            i,
          ),
    ].where((student) => student.name.isNotEmpty).toList();
  }

  static List<StudentAttendance> parseSavedAttendance(
    dynamic response, {
    List<StudentAttendance> existing = const [],
  }) {
    final raw = _studentList(response);
    if (raw.isEmpty) return existing;

    final byId = <String, StudentAttendance>{};
    void indexStudent(StudentAttendance student) {
      void add(String? value) {
        final key = value?.trim() ?? '';
        if (key.isEmpty) return;
        byId[key] = student;
      }

      add(student.id);
      add('${student.stdId}');
    }

    for (final student in existing) {
      indexStudent(student);
    }

    final saved = <StudentAttendance>[];
    for (var i = 0; i < raw.length; i++) {
      if (raw[i] is! Map) continue;
      final json = Map<String, dynamic>.from(raw[i] as Map);
      final parsed = StudentAttendance.fromJson(json, i);
      final previous = byId[parsed.id.trim()] ??
          byId['${parsed.stdId ?? ''}'] ??
          (i < existing.length ? existing[i] : null);
      saved.add(
        StudentAttendance(
          id: parsed.id,
          roll: i + 1,
          name: parsed.name.isNotEmpty
              ? parsed.name
              : (previous?.name ?? 'ID ${parsed.id}'),
          stdId: parsed.stdId ?? previous?.stdId,
          guardianNumber: parsed.guardianNumber ?? previous?.guardianNumber,
          status: parsed.status,
        ),
      );
    }
    return saved.isEmpty ? existing : saved;
  }
}
