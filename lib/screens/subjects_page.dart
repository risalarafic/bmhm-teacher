import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../bloc/subjects_bloc/subjects_bloc.dart';
import '../bloc/subjects_bloc/subjects_bloc_model.dart';
import '../service/base_service.dart';
import '../utils/constants/colors.dart';
import '../widgets/subjects/subject_card.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key, required this.bloc});

  final SubjectsBloc bloc;

  static Widget create(BuildContext context) {
    final service = Provider.of<BaseService>(context, listen: false);
    return Provider<SubjectsBloc>(
      create: (_) => SubjectsBloc(service: service),
      child: Consumer<SubjectsBloc>(
        builder: (_, bloc, _) => SubjectsPage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  SubjectsBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.load(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SubjectsBlocModel>(
      stream: bloc.modelStream,
      initialData: bloc.current,
      builder: (context, snapshot) {
        final model = snapshot.data ?? SubjectsBlocModel();
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
                'My Subjects',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            body: _body(model),
          ),
        );
      },
    );
  }

  Widget _body(SubjectsBlocModel model) {
    if (model.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (model.subjects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            model.error ?? 'No subjects assigned.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: model.subjects.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.28,
      ),
      itemBuilder: (context, index) {
        return SubjectCard(subject: model.subjects[index]);
      },
    );
  }
}
