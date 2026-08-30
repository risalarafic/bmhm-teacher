class Homework {
  const Homework({
    required this.id,
    required this.title,
    required this.details,
    required this.classLabel,
    required this.date,
    this.attachmentName,
  });

  final String id;
  final String title;
  final String details;
  final String classLabel;
  final DateTime date;
  final String? attachmentName;
}
