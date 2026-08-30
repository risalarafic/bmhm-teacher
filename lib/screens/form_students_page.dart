import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../bloc/form_students_bloc/form_students_bloc.dart';
import '../bloc/form_students_bloc/form_students_bloc_model.dart';
import '../service/base_service.dart';
import '../utils/constants/colors.dart';
import '../widgets/form_students/form_student_tile.dart';

class FormStudentsPage extends StatefulWidget {
  const FormStudentsPage({super.key, required this.bloc});

  final FormStudentsBloc bloc;

  static Widget create(BuildContext context) {
    final service = Provider.of<BaseService>(context, listen: false);
    return Provider<FormStudentsBloc>(
      create: (_) => FormStudentsBloc(service: service),
      child: Consumer<FormStudentsBloc>(
        builder: (_, bloc, _) => FormStudentsPage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<FormStudentsPage> createState() => _FormStudentsPageState();
}

class _FormStudentsPageState extends State<FormStudentsPage> {
  FormStudentsBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.load(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FormStudentsBlocModel>(
      stream: bloc.modelStream,
      initialData: bloc.current,
      builder: (context, snapshot) {
        final model = snapshot.data ?? FormStudentsBlocModel();
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: AppColors.bg,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Form Students',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  if (model.formClass.isNotEmpty)
                    Text(
                      model.formClass,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            body: _body(model),
          ),
        );
      },
    );
  }

  Widget _body(FormStudentsBlocModel model) {
    if (model.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (model.students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            model.error ?? 'No students found.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: model.students.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return FormStudentTile(student: model.students[index]);
      },
    );
  }
}
