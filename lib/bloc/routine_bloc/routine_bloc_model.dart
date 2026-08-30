import '../../models/class_routine.dart';

class RoutineBlocModel {
  RoutineBlocModel({
    this.isLoading = true,
    this.routine = const ClassRoutine(slots: []),
    this.selectedWeekday = 1,
    this.error,
  });

  final bool isLoading;
  final ClassRoutine routine;
  final int selectedWeekday;
  final String? error;

  List<RoutineSlot> get daySlots => routine.slotsFor(selectedWeekday);

  RoutineBlocModel copyWith({
    bool? isLoading,
    ClassRoutine? routine,
    int? selectedWeekday,
    String? error,
    bool clearError = false,
  }) {
    return RoutineBlocModel(
      isLoading: isLoading ?? this.isLoading,
      routine: routine ?? this.routine,
      selectedWeekday: selectedWeekday ?? this.selectedWeekday,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
