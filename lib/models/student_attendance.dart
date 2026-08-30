enum AttendanceStatus { present, absent, late }

class StudentAttendance {
  const StudentAttendance({
    required this.id,
    required this.roll,
    required this.name,
    this.stdId,
    this.status = AttendanceStatus.present,
  });

  final String id;
  final int roll;
  final String name;
  final int? stdId;
  final AttendanceStatus status;

  factory StudentAttendance.fromJson(Map<String, dynamic> json, int index) {
    int? parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse('$value');
    }

    return StudentAttendance(
      id: json['id']?.toString() ?? json['stdid']?.toString() ?? '$index',
      stdId: parseInt(json['stdid']),
      roll: index + 1,
      name: json['name']?.toString().trim() ?? '',
    );
  }

  StudentAttendance copyWith({AttendanceStatus? status}) {
    return StudentAttendance(
      id: id,
      roll: roll,
      name: name,
      stdId: stdId,
      status: status ?? this.status,
    );
  }

  static List<StudentAttendance> parseFormStudents(dynamic response) {
    List<dynamic> raw = const [];
    if (response is List) {
      raw = response;
    } else if (response is Map) {
      final value = response['formstudents'] ??
          response['form_students'] ??
          response['students'] ??
          response['data'];
      if (value is List) raw = value;
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
}
