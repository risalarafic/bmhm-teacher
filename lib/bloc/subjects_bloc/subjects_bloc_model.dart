import '../../models/teacher_subject.dart';

class SubjectsBlocModel {
  SubjectsBlocModel({
    this.isLoading = true,
    this.subjects = const [],
    this.error,
  });

  final bool isLoading;
  final List<TeacherSubject> subjects;
  final String? error;

  SubjectsBlocModel copyWith({
    bool? isLoading,
    List<TeacherSubject>? subjects,
    String? error,
    bool clearError = false,
  }) {
    return SubjectsBlocModel(
      isLoading: isLoading ?? this.isLoading,
      subjects: subjects ?? this.subjects,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
