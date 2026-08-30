import '../../models/student_attendance.dart';

class FormStudentsBlocModel {
  FormStudentsBlocModel({
    this.isLoading = true,
    this.students = const [],
    this.formClass = '',
    this.error,
  });

  final bool isLoading;
  final List<StudentAttendance> students;
  final String formClass;
  final String? error;

  FormStudentsBlocModel copyWith({
    bool? isLoading,
    List<StudentAttendance>? students,
    String? formClass,
    String? error,
    bool clearError = false,
  }) {
    return FormStudentsBlocModel(
      isLoading: isLoading ?? this.isLoading,
      students: students ?? this.students,
      formClass: formClass ?? this.formClass,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
