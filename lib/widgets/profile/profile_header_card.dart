import 'package:flutter/material.dart';

import '../../bloc/home_bloc/home_bloc_model.dart';
import '../../utils/constants/colors.dart';
import '../teacher_avatar.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, required this.model});

  final HomeBlocModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TeacherAvatar(
            name: model.teacherName,
            imageUrl: model.teacherImage,
            radius: 42,
          ),
          const SizedBox(height: 14),
          Text(
            model.teacherName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            model.teacherEmail,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${model.teacherId}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          if (model.formClass.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Form: ${model.formClass}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
