import 'package:flutter/material.dart';

import '../../bloc/attendance_bloc/attendance_bloc_model.dart';
import '../../utils/constants/colors.dart';

class AttendanceSummaryRow extends StatelessWidget {
  const AttendanceSummaryRow({
    super.key,
    required this.model,
    required this.onMarkAllPresent,
  });

  final AttendanceBlocModel model;
  final VoidCallback onMarkAllPresent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CountDot(color: AppColors.primary, label: '${model.presentCount} Present'),
        const SizedBox(width: 12),
        _CountDot(color: AppColors.red, label: '${model.absentCount} Absent'),
        const SizedBox(width: 12),
        _CountDot(color: AppColors.late, label: '${model.lateCount} Late'),
        const Spacer(),
        TextButton(
          onPressed: onMarkAllPresent,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Mark all present',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _CountDot extends StatelessWidget {
  const _CountDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
