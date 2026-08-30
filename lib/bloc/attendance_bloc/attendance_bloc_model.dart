import '../../models/student_attendance.dart';

class AttendanceBlocModel {
  AttendanceBlocModel({
    this.grade,
    this.section,
    DateTime? date,
    this.students = const [],
    this.isSubmitting = false,
    this.isLoading = false,
  }) : date = date ?? DateTime.now();

  final String? grade;
  final String? section;
  final DateTime date;
  final List<StudentAttendance> students;
  final bool isSubmitting;
  final bool isLoading;

  bool get hasSelection =>
      (grade != null && grade!.isNotEmpty) &&
      (section != null && section!.isNotEmpty);

  String get formClass {
    final g = grade?.trim() ?? '';
    final s = section?.trim() ?? '';
    if (g.isEmpty) return s;
    if (s.isEmpty) return g;
    return '$g - $s';
  }

  int get presentCount =>
      students.where((s) => s.status == AttendanceStatus.present).length;

  int get absentCount =>
      students.where((s) => s.status == AttendanceStatus.absent).length;

  int get lateCount =>
      students.where((s) => s.status == AttendanceStatus.late).length;

  AttendanceBlocModel copyWith({
    String? grade,
    String? section,
    DateTime? date,
    List<StudentAttendance>? students,
    bool? isSubmitting,
    bool? isLoading,
    bool clearGrade = false,
    bool clearSection = false,
  }) {
    return AttendanceBlocModel(
      grade: clearGrade ? null : (grade ?? this.grade),
      section: clearSection ? null : (section ?? this.section),
      date: date ?? this.date,
      students: students ?? this.students,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
