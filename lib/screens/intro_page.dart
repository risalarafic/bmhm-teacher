import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/intro_bloc/intro_bloc.dart';
import '../bloc/intro_bloc/intro_bloc_model.dart';
import '../l10n/app_localizations.dart';
import '../service/base_service.dart';
import '../utils/common_methods.dart';
import '../utils/constants/app_assets.dart';
import '../utils/constants/colors.dart';
import '../widgets/app_button/app_button.dart';
import '../widgets/app_text/app_texts.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key, required this.bloc});

  final IntroBloc bloc;

  static Widget create(BuildContext context) {
    final service = Provider.of<BaseService>(context, listen: false);
    return Provider<IntroBloc>(
      create: (_) => IntroBloc(service: service),
      child: Consumer<IntroBloc>(
        builder: (_, bloc, _) => IntroPage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  IntroBloc get bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<IntroBlocModel>(
      stream: bloc.modelStream,
      initialData: IntroBlocModel(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => bloc.finish(context),
                      child: AppText(l10n.skip, color: AppColors.primary),
                    ),
                  ),
                  const Spacer(),
                  const Image(image: AssetImage(appLogo), width: 160),
                  const SizedBox(height: 24),
                  AppText(
                    l10n.appTitle,
                    size: 24,
                    textType: TextWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    l10n.welcome,
                    size: 16,
                    color: AppColors.grey,
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    onPressed: () => bloc.finish(context),
                    child: AppText(l10n.next, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
