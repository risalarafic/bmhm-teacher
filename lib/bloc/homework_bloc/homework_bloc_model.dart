import '../../models/homework.dart';
import '../../models/notice.dart';

class HomeworkBlocModel {
  HomeworkBlocModel({
    this.tabIndex = 0,
    List<Homework>? homeworks,
    List<Notice>? notices,
  })  : homeworks = homeworks ?? const [],
        notices = notices ?? const [];

  final int tabIndex;
  final List<Homework> homeworks;
  final List<Notice> notices;

  HomeworkBlocModel copyWith({
    int? tabIndex,
    List<Homework>? homeworks,
    List<Notice>? notices,
  }) {
    return HomeworkBlocModel(
      tabIndex: tabIndex ?? this.tabIndex,
      homeworks: homeworks ?? this.homeworks,
      notices: notices ?? this.notices,
    );
  }
}
