import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class AttendancePickerOption {
  const AttendancePickerOption({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}

Future<String?> showAttendancePickerSheet(
  BuildContext context, {
  required String title,
  required List<AttendancePickerOption> options,
  required IconData icon,
  bool boxedIcon = true,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99000000),
    builder: (context) {
      return SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return InkWell(
                      onTap: () => Navigator.pop(context, option.value),
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          boxedIcon
                              ? Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    icon,
                                    size: 16,
                                    color: AppColors.white,
                                  ),
                                )
                              : Icon(
                                  icon,
                                  size: 26,
                                  color: AppColors.primary,
                                ),
                          const SizedBox(width: 14),
                          Text(
                            option.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: boxedIcon
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
