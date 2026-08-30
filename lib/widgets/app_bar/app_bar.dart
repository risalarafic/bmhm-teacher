import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../app_text/app_texts.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      title: AppText(title, color: AppColors.white, size: 18),
      actions: actions,
    );
  }
}
