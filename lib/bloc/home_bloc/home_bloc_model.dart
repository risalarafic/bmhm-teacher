import '../../models/home.dart';
import '../../models/next_class.dart';

class HomeBlocModel {
  HomeBlocModel({
    this.isLoading = true,
    this.navigationIndex = 0,
    this.home,
    this.teacherName = 'Mr. Moshiur Rahman',
    this.teacherRole = 'Teacher',
    String? teacherEmail,
    this.teacherId = '858',
    this.formClass = 'G-X - D',
    this.teacherImage,
    this.nextClass,
  }) : _teacherEmail = teacherEmail;

  final bool isLoading;
  final int navigationIndex;
  final Home? home;
  final String teacherName;
  final String teacherRole;
  final String? _teacherEmail;
  String get teacherEmail {
    final email = _teacherEmail;
    if (email == null || email.isEmpty) return 'moshiur@bmhm-qa.org';
    return email;
  }
  final String teacherId;
  final String formClass;
  final String? teacherImage;
  final NextClass? nextClass;

  HomeBlocModel copyWith({
    bool? isLoading,
    int? navigationIndex,
    Home? home,
    String? teacherName,
    String? teacherRole,
    String? teacherEmail,
    String? teacherId,
    String? formClass,
    String? teacherImage,
    NextClass? nextClass,
    bool clearNextClass = false,
  }) {
    return HomeBlocModel(
      isLoading: isLoading ?? this.isLoading,
      navigationIndex: navigationIndex ?? this.navigationIndex,
      home: home ?? this.home,
      teacherName: teacherName ?? this.teacherName,
      teacherRole: teacherRole ?? this.teacherRole,
      teacherEmail: teacherEmail ?? _teacherEmail,
      teacherId: teacherId ?? this.teacherId,
      formClass: formClass ?? this.formClass,
      teacherImage: teacherImage ?? this.teacherImage,
      nextClass: clearNextClass ? null : (nextClass ?? this.nextClass),
    );
  }
}
