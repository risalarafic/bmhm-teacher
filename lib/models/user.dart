import '../utils/media_url.dart';

class Teacher {
  Teacher({
    this.id,
    this.hrid,
    this.name,
    this.email,
    this.username,
    this.token,
    this.image,
    this.role,
    this.formGrade,
    this.formSection,
  });

  final int? id;
  final int? hrid;
  final String? name;
  final String? email;
  final String? username;
  final String? token;
  final String? image;
  final String? role;
  final String? formGrade;
  final String? formSection;

  int? get displayId => hrid ?? id;

  String get formClass {
    final grade = formGrade?.trim() ?? '';
    final section = formSection?.trim() ?? '';
    if (grade.isEmpty) return section;
    if (section.isEmpty) return grade;
    return '$grade - $section';
  }

  String? get imageUrl => MediaUrl.resolve(image);

  List<String> get imageUrlCandidates => MediaUrl.candidates(image);

  factory Teacher.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse('$value');
    }

    return Teacher(
      id: parseInt(json['id']),
      hrid: parseInt(json['hrid']),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      token: (json['token'] ?? json['auth_token'])?.toString(),
      image: (json['picture'] ?? json['image'])
          ?.toString()
          .replaceAll('\\', '/'),
      role: json['role']?.toString() ?? 'Teacher',
      formGrade: json['form_grade']?.toString(),
      formSection: json['form_section']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hrid': hrid,
      'name': name,
      'email': email,
      'username': username,
      'token': token,
      'auth_token': token,
      'picture': image,
      'image': image,
      'role': role,
      'form_grade': formGrade,
      'form_section': formSection,
    };
  }
}
