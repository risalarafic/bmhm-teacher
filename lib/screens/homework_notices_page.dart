import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/homework_bloc/homework_bloc.dart';
import '../bloc/homework_bloc/homework_bloc_model.dart';
import '../service/base_service.dart';
import '../utils/constants/colors.dart';
import '../widgets/homework/new_homework_sheet.dart';
import '../widgets/homework/new_notice_sheet.dart';
import '../widgets/homework/task_item_card.dart';

class HomeworkNoticesPage extends StatelessWidget {
  const HomeworkNoticesPage({super.key, required this.bloc});

  final HomeworkBloc bloc;

  static Widget create(BuildContext context) {
    try {
      final existing = Provider.of<HomeworkBloc>(context, listen: false);
      return HomeworkNoticesPage(bloc: existing);
    } catch (_) {
      final service = Provider.of<BaseService>(context, listen: false);
      return Provider<HomeworkBloc>(
        create: (_) => HomeworkBloc(service: service),
        child: Consumer<HomeworkBloc>(
          builder: (_, bloc, _) => HomeworkNoticesPage(bloc: bloc),
        ),
        dispose: (_, bloc) => bloc.dispose(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeworkBlocModel>(
      stream: bloc.modelStream,
      initialData: bloc.current,
      builder: (context, snapshot) {
        final model = snapshot.data ?? HomeworkBlocModel();
        final isHomework = model.tabIndex == 0;
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text(
                        'Homework & Notices',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _TabLabel(
                          label: 'Homework',
                          selected: isHomework,
                          onTap: () => bloc.selectTab(0),
                        ),
                        _TabLabel(
                          label: 'Notices',
                          selected: !isHomework,
                          onTap: () => bloc.selectTab(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    children: isHomework
                        ? model.homeworks
                            .map(
                              (item) => TaskItemCard(
                                title: item.title,
                                details: item.details,
                                badge: item.classLabel,
                                dateLabel: bloc.formatDate(item.date),
                              ),
                            )
                            .toList()
                        : model.notices
                            .map(
                              (item) => TaskItemCard(
                                title: item.title,
                                details: item.details,
                                badge: item.audience,
                                dateLabel: bloc.formatDate(item.date),
                              ),
                            )
                            .toList(),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Material(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                      child: InkWell(
                        onTap: () {
                          if (isHomework) {
                            showNewHomeworkSheet(context, bloc);
                          } else {
                            showNewNoticeSheet(context, bloc);
                          }
                        },
                        borderRadius: BorderRadius.circular(28),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: AppColors.white, size: 20),
                              SizedBox(width: 6),
                              Text(
                                'New',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                label,
                style: TextStyle(
                  color: selected
                      ? AppColors.white
                      : AppColors.white.withValues(alpha: 0.55),
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: selected ? 72 : 0,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
