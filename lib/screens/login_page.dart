import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_bloc_model.dart';
import '../service/base_service.dart';
import '../utils/constants/app_assets.dart';
import '../utils/constants/colors.dart';
import '../widgets/login_card/login_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.bloc});

  final LoginBloc bloc;

  static Widget create(BuildContext context) {
    final service = Provider.of<BaseService>(context, listen: false);
    return Provider<LoginBloc>(
      create: (_) => LoginBloc(service: service),
      child: Consumer<LoginBloc>(
        builder: (_, bloc, _) => LoginPage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc get bloc => widget.bloc;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoginBlocModel>(
      stream: bloc.modelStream,
      initialData: LoginBlocModel(),
      builder: (context, snapshot) {
        final model = snapshot.data ?? LoginBlocModel();
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: AppColors.loginGreen,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Image.asset(
                              schoolCrest,
                              height: 176,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'BANGLADESH',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                                letterSpacing: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'MHM',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 42,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'SCHOOL & COLLEGE',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                letterSpacing: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Teacher Portal',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 28),
                            LoginCard(
                              bloc: bloc,
                              model: model,
                              emailController: _emailController,
                              passwordController: _passwordController,
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'Developed by SkilledQatar.Com',
                              style: TextStyle(
                                color: AppColors.white.withValues(alpha: 0.92),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
