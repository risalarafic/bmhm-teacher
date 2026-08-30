import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/attendance_bloc/attendance_bloc.dart';
import '../bloc/attendance_bloc/attendance_bloc_model.dart';
import '../service/base_service.dart';
import '../utils/constants/colors.dart';
import '../widgets/attendance/attendance_filter_card.dart';
import '../widgets/attendance/attendance_summary_row.dart';
import '../widgets/attendance/student_attendance_tile.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({
    super.key,
    required this.bloc,
    this.showBack = false,
  });

  final AttendanceBloc bloc;
  final bool showBack;

  static Widget create(
    BuildContext context, {
    bool showBack = false,
  }) {
    final existing = _existingBloc(context);
    if (existing != null) {
      return AttendancePage(bloc: existing, showBack: showBack);
    }
    final service = Provider.of<BaseService>(context, listen: false);
    return Provider<AttendanceBloc>(
      create: (_) => AttendanceBloc(service: service),
      child: Consumer<AttendanceBloc>(
        builder: (_, bloc, _) => AttendancePage(
          bloc: bloc,
          showBack: showBack,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  static AttendanceBloc? _existingBloc(BuildContext context) {
    try {
      return Provider.of<AttendanceBloc>(context, listen: false);
    } catch (_) {
      return null;
    }
  }

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  AttendanceBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AttendanceBlocModel>(
      stream: bloc.modelStream,
      initialData: bloc.current,
      builder: (context, snapshot) {
        final model = snapshot.data ?? AttendanceBlocModel();
        final content = Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: AttendanceFilterCard(bloc: bloc, model: model),
            ),
            if (model.hasSelection) ...[
              if (model.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (model.students.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No students found.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: AttendanceSummaryRow(
                    model: model,
                    onMarkAllPresent: bloc.markAllPresent,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    itemCount: model.students.length,
                    itemBuilder: (context, index) {
                      final student = model.students[index];
                      return StudentAttendanceTile(
                        student: student,
                        onStatusChanged: (status) =>
                            bloc.setStatus(student.id, status),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed:
                          model.isSubmitting ? null : () => bloc.submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 20),
                      label: Text(
                        model.isSubmitting ? 'Submitting...' : 'Submit attendance',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ] else
              const Expanded(
                child: Center(
                  child: Text(
                    'Select grade and section to mark attendance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        );

        if (!widget.showBack) return content;

        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              'Attendance',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          body: content,
        );
      },
    );
  }
}
