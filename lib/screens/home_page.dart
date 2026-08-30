import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../bloc/attendance_bloc/attendance_bloc.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/home_bloc/home_bloc_model.dart';
import '../bloc/homework_bloc/homework_bloc.dart';
import '../service/base_service.dart';
import '../utils/constants/colors.dart';
import '../widgets/app_bottom_bar/app_bottom_bar.dart';
import '../widgets/dashboard/menu_grid.dart';
import '../widgets/dashboard/profile_card.dart';
import '../widgets/dashboard/reminder_card.dart';
import 'attendance_page.dart';
import 'homework_notices_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.bloc});

  final HomeBloc bloc;

  static Widget create(BuildContext context) {
    final service = Provider.of<BaseService>(context, listen: false);
    return MultiProvider(
      providers: [
        Provider<HomeBloc>(
          create: (_) => HomeBloc(service: service),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<AttendanceBloc>(
          create: (_) => AttendanceBloc(service: service),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<HomeworkBloc>(
          create: (_) => HomeworkBloc(service: service),
          dispose: (_, bloc) => bloc.dispose(),
        ),
      ],
      child: Consumer<HomeBloc>(
        builder: (_, bloc, _) => HomePage(bloc: bloc),
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc get bloc => widget.bloc;

  static const _titles = ['Dashboard', 'Attendance', 'Homework & Notices', 'Profile'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeBlocModel>(
      stream: bloc.modelStream,
      initialData: bloc.currentModel,
      builder: (context, snapshot) {
        final model = snapshot.data ?? HomeBlocModel(isLoading: false);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: AppColors.bg,
            appBar: model.navigationIndex == 2
                ? null
                : AppBar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    centerTitle: model.navigationIndex == 1,
                    title: Text(
                      _titles[model.navigationIndex],
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    actions: model.navigationIndex == 0
                        ? [
                            IconButton(
                              onPressed: () => bloc.onNotificationsTap(context),
                              icon: const Icon(Icons.notifications_outlined),
                            ),
                          ]
                        : null,
                  ),
            body: IndexedStack(
              index: model.navigationIndex,
              children: [
                _DashboardTab(bloc: bloc, model: model),
                AttendancePage.create(context),
                HomeworkNoticesPage.create(context),
                ProfilePage(bloc: bloc, model: model),
              ],
            ),
            bottomNavigationBar: AppBottomBar(
              currentIndex: model.navigationIndex,
              onTap: bloc.updateNavIndex,
            ),
          ),
        );
      },
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({required this.bloc, required this.model});

  final HomeBloc bloc;
  final HomeBlocModel model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        children: [
          DashboardProfileCard(model: model),
          const SizedBox(height: 12),
          NextClassReminderCard(
            nextClass: model.nextClass,
            onTap: () => bloc.onReminderTap(context),
          ),
          const SizedBox(height: 16),
          DashboardMenuGrid(
            onItemTap: (id) {
              if (id == 'homework' || id == 'notices') {
                final homeworkBloc = Provider.of<HomeworkBloc>(
                  context,
                  listen: false,
                );
                homeworkBloc.selectTab(id == 'notices' ? 1 : 0);
                bloc.updateNavIndex(2);
                return;
              }
              bloc.onMenuTap(context, id);
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Developed by SkilledQatar.Com',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
