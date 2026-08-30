import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../bloc/routine_bloc/routine_bloc.dart';
import '../bloc/routine_bloc/routine_bloc_model.dart';
import '../models/class_routine.dart';
import '../service/base_service.dart';
import '../utils/constants/colors.dart';
import '../widgets/routine/routine_period_tile.dart';

class ClassRoutinePage extends StatefulWidget {
  const ClassRoutinePage({super.key, required this.bloc});

  final RoutineBloc bloc;

  static Widget create(BuildContext context) {
    final service = Provider.of<BaseService>(context, listen: false);
    return Provider<RoutineBloc>(
      create: (_) => RoutineBloc(service: service),
      child: Consumer<RoutineBloc>(
        builder: (_, bloc, _) => ClassRoutinePage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<ClassRoutinePage> createState() => _ClassRoutinePageState();
}

class _ClassRoutinePageState extends State<ClassRoutinePage> {
  RoutineBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.load(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RoutineBlocModel>(
      stream: bloc.modelStream,
      initialData: bloc.current,
      builder: (context, snapshot) {
        final model = snapshot.data ?? RoutineBlocModel();
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
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
                'Class Routine',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            body: Column(
              children: [
                _DayChips(
                  selected: model.selectedWeekday,
                  onSelect: bloc.selectWeekday,
                ),
                Expanded(child: _body(model)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(RoutineBlocModel model) {
    if (model.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (model.error != null && model.routine.slots.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            model.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.grey, fontSize: 15),
          ),
        ),
      );
    }

    final slots = model.daySlots;
    if (slots.isEmpty) {
      return Center(
        child: Text(
          'No classes on ${ClassRoutine.weekdayLabelFor(model.selectedWeekday)}.',
          style: const TextStyle(color: AppColors.grey, fontSize: 15),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: slots.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return RoutinePeriodTile(slot: slots[index]);
      },
    );
  }
}

class _DayChips extends StatelessWidget {
  const _DayChips({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: ClassRoutine.schoolWeekdays.map((day) {
          final isSelected = day == selected;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: day == 5 ? 0 : 6),
              child: Material(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => onSelect(day),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      ClassRoutine.weekdayShortFor(day),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isSelected ? AppColors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
