class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.details,
    required this.date,
    this.audience = 'All',
    this.attachmentName,
  });

  final String id;
  final String title;
  final String details;
  final DateTime date;
  final String audience;
  final String? attachmentName;
}
