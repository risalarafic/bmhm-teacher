class Home {
  Home({
    this.title,
    this.subtitle,
    this.classes = const [],
  });

  final String? title;
  final String? subtitle;
  final List<String> classes;

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString(),
      classes: (json['classes'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'classes': classes,
    };
  }
}
