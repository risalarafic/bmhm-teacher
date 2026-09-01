import 'package:flutter/material.dart';

import '../../models/student_attendance.dart';
import '../../utils/constants/colors.dart';

class StudentAttendanceTile extends StatelessWidget {
  const StudentAttendanceTile({
    super.key,
    required this.student,
    required this.onStatusChanged,
    this.enabled = true,
  });

  final StudentAttendance student;
  final ValueChanged<AttendanceStatus> onStatusChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.yellowSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              student.roll.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: ${student.stdId ?? student.id}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _StatusChip(
            label: 'P',
            selected: student.status == AttendanceStatus.present,
            selectedColor: AppColors.primary,
            unselectedColor: AppColors.primary.withValues(alpha: 0.12),
            unselectedText: AppColors.primary,
            onTap: enabled
                ? () => onStatusChanged(AttendanceStatus.present)
                : null,
          ),
          const SizedBox(width: 6),
          _StatusChip(
            label: 'A',
            selected: student.status == AttendanceStatus.absent,
            selectedColor: AppColors.red,
            unselectedColor: AppColors.absentBg,
            unselectedText: AppColors.red,
            onTap: enabled
                ? () => onStatusChanged(AttendanceStatus.absent)
                : null,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.unselectedText,
    this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final Color unselectedText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : unselectedText,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
