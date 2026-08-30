import 'dart:async';

import 'package:intl/intl.dart';

import '../../models/homework.dart';
import '../../models/notice.dart';
import '../../service/base_service.dart';
import 'homework_bloc_model.dart';

class HomeworkBloc {
  HomeworkBloc({required this.service}) {
    _model = HomeworkBlocModel(
      homeworks: _demoHomework(),
      notices: _demoNotices(),
    );
  }

  final BaseService service;
  final StreamController<HomeworkBlocModel> _modelController =
      StreamController<HomeworkBlocModel>();

  Stream<HomeworkBlocModel> get modelStream => _modelController.stream;
  late HomeworkBlocModel _model;
  HomeworkBlocModel get current => _model;

  static const classOptions = [
    'G-IX - A',
    'G-IX - B',
    'G-VII - C',
    'G-VIII - A',
    'G-VIII - B',
    'G-X - C',
    'G-X - D',
    'G-XII - A',
    'G-XII - B',
  ];

  void dispose() {
    _modelController.close();
  }

  void _emit() => _modelController.add(_model);

  void selectTab(int index) {
    _model = _model.copyWith(tabIndex: index);
    _emit();
  }

  void publishHomework({
    required String title,
    required String details,
    required String classLabel,
    String? attachmentName,
  }) {
    final item = Homework(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      details: details,
      classLabel: classLabel,
      date: DateTime.now(),
      attachmentName: attachmentName,
    );
    _model = _model.copyWith(homeworks: [item, ..._model.homeworks]);
    _emit();
  }

  void publishNotice({
    required String title,
    required String details,
    String? attachmentName,
  }) {
    final item = Notice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      details: details,
      date: DateTime.now(),
      attachmentName: attachmentName,
    );
    _model = _model.copyWith(notices: [item, ..._model.notices]);
    _emit();
  }

  String formatDate(DateTime date) => DateFormat('d MMM yyyy').format(date);

  List<Homework> _demoHomework() {
    return [
      Homework(
        id: 'hw1',
        title: 'Algebra worksheet',
        details: 'Complete exercises 4.1 to 4.3 from the textbook.',
        classLabel: 'Class 6 - A',
        date: DateTime(2026, 8, 29),
      ),
      Homework(
        id: 'hw2',
        title: 'Science reading',
        details: 'Read chapter 3 and write a half-page summary.',
        classLabel: 'Class 7 - B',
        date: DateTime(2026, 8, 28),
      ),
    ];
  }

  List<Notice> _demoNotices() {
    return [
      Notice(
        id: 'n1',
        title: 'Parent-teacher meeting',
        details: 'PTM scheduled this Thursday at 10 AM in the main hall.',
        date: DateTime(2026, 8, 30),
      ),
    ];
  }
}
