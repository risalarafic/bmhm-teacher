import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../bloc/splash_bloc/splash_bloc.dart';
import '../bloc/splash_bloc/splash_bloc_model.dart';
import '../push_notification.dart';
import '../service/base_service.dart';
import '../utils/common_methods.dart';
import '../utils/constants/app_assets.dart';
import '../utils/constants/colors.dart';
import 'home_page.dart';
import 'intro_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.bloc});

  final SplashBloc bloc;

  static Widget create(BuildContext context) {
    final service = Provider.of<BaseService>(context, listen: false);
    return Provider<SplashBloc>(
      create: (_) => SplashBloc(service: service),
      child: Consumer<SplashBloc>(
        builder: (_, bloc, _) => SplashPage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _start();
    });
  }

  Future<void> _start() async {
    await PushNotification().initialize();
    if (!mounted) return;
    await bloc.init(context);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    switch (bloc.navigationOption) {
      case SplashNavigationOption.home:
        openAsNewPage(context, HomePage.create(context));
      case SplashNavigationOption.intro:
        openAsNewPage(context, IntroPage.create(context));
      case SplashNavigationOption.signInOption:
      case SplashNavigationOption.noInfo:
        openAsNewPage(context, LoginPage.create(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SplashBlocModel>(
      stream: bloc.modelStream,
      initialData: SplashBlocModel(),
      builder: (context, snapshot) {
        return const Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child: Image(
              image: AssetImage(schoolCrest),
              width: 220,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
