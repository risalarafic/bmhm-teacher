class TeacherSubject {
  TeacherSubject({
    this.id,
    this.subjectId,
    required this.name,
    required this.classLabel,
  });

  final String? id;
  final String? subjectId;
  final String name;
  final String classLabel;

  factory TeacherSubject.fromJson(Map<String, dynamic> json) {
    final name = _firstNonEmpty(json, const [
      'subjectname',
      'subject_name',
      'subject',
      'sub_name',
      'subname',
      'name',
      'title',
    ]);
    final grade = _firstNonEmpty(json, const [
      'grade',
      'form_grade',
      'class',
      'class_name',
      'classname',
      'stdclass',
    ]);
    final section = _firstNonEmpty(json, const [
      'section',
      'form_section',
      'sec',
    ]);

    return TeacherSubject(
      id: json['id']?.toString(),
      subjectId: json['subjectid']?.toString() ?? json['subject_id']?.toString(),
      name: name,
      classLabel: _classLabel(grade, section),
    );
  }

  static List<TeacherSubject> parseResponse(dynamic response) {
    final subjects = <TeacherSubject>[];
    if (response is List) {
      _collect(response, subjects);
      return subjects;
    }
    if (response is Map) {
      final nested = response['subjects'] ?? response['data'] ?? response;
      _collect(nested, subjects);
    }
    return subjects;
  }

  static void _collect(dynamic node, List<TeacherSubject> out) {
    if (node is List) {
      for (final item in node) {
        _collect(item, out);
      }
      return;
    }
    if (node is! Map) return;
    final map = Map<String, dynamic>.from(node);
    final isSubject = map.containsKey('subjectname') ||
        map.containsKey('subject_name') ||
        map.containsKey('subjectid') ||
        (map.containsKey('grade') && map.containsKey('section'));
    if (isSubject) {
      final parsed = TeacherSubject.fromJson(map);
      if (parsed.name.isNotEmpty) out.add(parsed);
      return;
    }
    for (final value in map.values) {
      _collect(value, out);
    }
  }

  static String _classLabel(String grade, String section) {
    if (grade.isEmpty) return section;
    if (section.isEmpty) return grade;
    return '$grade - $section';
  }

  static String _firstNonEmpty(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key]?.toString().trim() ?? '';
      if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
    }
    return '';
  }
}
