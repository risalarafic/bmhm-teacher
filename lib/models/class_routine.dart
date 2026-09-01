import 'next_class.dart';

class RoutineSlot {
  const RoutineSlot({
    required this.weekday,
    required this.periodId,
    required this.subjectName,
    required this.startMinutes,
    required this.endMinutes,
    required this.timeRange,
    this.grade = '',
    this.section = '',
  });

  /// API weekday: 1 = Sunday … 5 = Thursday.
  final int weekday;
  final int periodId;
  final String subjectName;
  final int startMinutes;
  final int endMinutes;
  final String timeRange;
  final String grade;
  final String section;

  String get classLabel {
    if (grade.isEmpty) return section;
    if (section.isEmpty) return grade;
    return '$grade - $section';
  }

  String get weekdayLabel {
    const names = ['', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
    if (weekday < 1 || weekday >= names.length) return '';
    return names[weekday];
  }

  String get weekdayShort {
    const names = ['', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
    if (weekday < 1 || weekday >= names.length) return '';
    return names[weekday];
  }
}

class ClassRoutine {
  const ClassRoutine({required this.slots});

  final List<RoutineSlot> slots;

  factory ClassRoutine.fromJson(Map<String, dynamic> json) {
    final timings = _parseTimings(json['timings']);
    final routine = json['routine'];
    final slots = <RoutineSlot>[];
    if (routine is! Map) return ClassRoutine(slots: slots);

    for (final dayEntry in routine.entries) {
      final weekday = int.tryParse('${dayEntry.key}');
      final periods = dayEntry.value;
      if (weekday == null || periods is! Map) continue;
      for (final periodEntry in periods.entries) {
        final cell = periodEntry.value;
        if (cell is! Map) continue;
        final map = Map<String, dynamic>.from(cell);
        final periodId = int.tryParse('${map['periodid'] ?? periodEntry.key}') ?? 0;
        final subject = map['subjectname']?.toString().trim() ?? '';
        if (subject.isEmpty) continue;
        final timing = timings[periodId];
        slots.add(
          RoutineSlot(
            weekday: weekday,
            periodId: periodId,
            subjectName: subject,
            startMinutes: timing?.$1 ?? periodId * 45,
            endMinutes: timing?.$2 ?? periodId * 45 + 40,
            timeRange: timing?.$3 ?? 'Period $periodId',
            grade: map['grade']?.toString().trim() ?? '',
            section: map['section']?.toString().trim() ?? '',
          ),
        );
      }
    }
    slots.sort((a, b) {
      final day = a.weekday.compareTo(b.weekday);
      if (day != 0) return day;
      return a.startMinutes.compareTo(b.startMinutes);
    });
    return ClassRoutine(slots: slots);
  }

  static const schoolWeekdays = [1, 2, 3, 4, 5];

  static String weekdayLabelFor(int weekday) {
    const names = ['', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
    if (weekday < 1 || weekday >= names.length) return '';
    return names[weekday];
  }

  static String weekdayShortFor(int weekday) {
    const names = ['', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
    if (weekday < 1 || weekday >= names.length) return '';
    return names[weekday];
  }

  List<RoutineSlot> slotsFor(int weekday) =>
      slots.where((s) => s.weekday == weekday).toList();

  List<int> get periodIds {
    final ids = slots.map((s) => s.periodId).toSet().toList()..sort();
    return ids;
  }

  String timeRangeFor(int periodId) {
    for (final slot in slots) {
      if (slot.periodId == periodId) return slot.timeRange;
    }
    return 'Period $periodId';
  }

  String subjectAt({required int weekday, required int periodId}) {
    return slotAt(weekday: weekday, periodId: periodId)?.subjectName ?? '';
  }

  String classLabelAt({required int weekday, required int periodId}) {
    return slotAt(weekday: weekday, periodId: periodId)?.classLabel ?? '';
  }

  RoutineSlot? slotAt({required int weekday, required int periodId}) {
    for (final slot in slots) {
      if (slot.weekday == weekday && slot.periodId == periodId) {
        return slot;
      }
    }
    return null;
  }

  /// School weekday 1–5 (Sun–Thu). Friday/Saturday fall back to Sunday.
  static int selectedWeekdayFor(DateTime date) => apiWeekday(date) ?? 1;

  NextClass? nextUpcoming({DateTime? now}) {
    if (slots.isEmpty) return null;
    final current = now ?? DateTime.now();
    final apiDay = apiWeekday(current);
    if (apiDay == null) return null;
    final daySlots = slots.where((s) => s.weekday == apiDay).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    final minutesNow = current.hour * 60 + current.minute;
    for (final slot in daySlots) {
      if (slot.endMinutes > minutesNow) {
        return _toNextClass(slot);
      }
    }
    return null;
  }

  static NextClass _toNextClass(RoutineSlot slot) {
    return NextClass(
      subject: slot.subjectName,
      section: slot.classLabel.isEmpty ? slot.weekdayLabel : slot.classLabel,
      timeRange: slot.timeRange,
      room: 'Period ${slot.periodId}',
    );
  }

  /// Dart weekday: Mon=1 … Sun=7. School days Sun–Thu map to API 1–5.
  static int? apiWeekday(DateTime date) {
    switch (date.weekday) {
      case DateTime.sunday:
        return 1;
      case DateTime.monday:
        return 2;
      case DateTime.tuesday:
        return 3;
      case DateTime.wednesday:
        return 4;
      case DateTime.thursday:
        return 5;
      default:
        return null;
    }
  }

  static Map<int, (int, int, String)> _parseTimings(dynamic raw) {
    final result = <int, (int, int, String)>{};
    if (raw is! Map) return result;
    final periodPattern = RegExp(r'Period\s*#?\s*(\d+)', caseSensitive: false);
    for (final entry in raw.entries) {
      final match = periodPattern.firstMatch('${entry.key}');
      if (match == null) continue;
      final periodId = int.tryParse(match.group(1) ?? '');
      if (periodId == null) continue;
      final range = '${entry.value}'.trim();
      final times = _parseRange(range);
      if (times == null) continue;
      result[periodId] = (times.$1, times.$2, range.replaceAll(' -', ' - '));
    }
    return result;
  }

  static (int, int)? _parseRange(String range) {
    final parts = range.split(RegExp(r'\s*-\s*'));
    if (parts.length < 2) return null;
    final start = _parseMinutes(parts[0]);
    var end = _parseMinutes(parts[1]);
    if (start == null || end == null) return null;
    if (end <= start) end += 12 * 60;
    return (start, end);
  }

  static int? _parseMinutes(String value) {
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(value.trim());
    if (match == null) return null;
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    return hour * 60 + minute;
  }
}
