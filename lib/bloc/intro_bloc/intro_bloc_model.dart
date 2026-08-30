class IntroBlocModel {
  IntroBlocModel({this.pageIndex = 0});

  final int pageIndex;

  IntroBlocModel copyWith({int? pageIndex}) {
    return IntroBlocModel(pageIndex: pageIndex ?? this.pageIndex);
  }
}
