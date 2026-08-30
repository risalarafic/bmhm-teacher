import 'package:flutter/material.dart';

import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/home_bloc/home_bloc_model.dart';
import '../utils/common_methods.dart';
import '../utils/constants/colors.dart';
import '../widgets/app_alert/app_alert_dialog.dart';
import '../widgets/profile/account_menu_card.dart';
import '../widgets/profile/profile_header_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.bloc,
    required this.model,
  });

  final HomeBloc bloc;
  final HomeBlocModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              ProfileHeaderCard(model: model),
              const SizedBox(height: 22),
              const Text(
                'ACCOUNT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              AccountMenuCard(
                items: [
                  AccountMenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Personal Information',
                    onTap: () => _comingSoon(context, 'Personal Information'),
                  ),
                  AccountMenuItem(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    onTap: () => _comingSoon(context, 'Change Password'),
                  ),
                  AccountMenuItem(
                    icon: Icons.settings_outlined,
                    label: 'App Settings',
                    onTap: () => _comingSoon(context, 'App Settings'),
                  ),
                  AccountMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    onTap: () => _comingSoon(context, 'About Us'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Material(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  onTap: () => _logout(context),
                  borderRadius: BorderRadius.circular(18),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: AppColors.red, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Text(
            'Developed by SkilledQatar.Com',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _comingSoon(BuildContext context, String label) {
    showSnackBarMessage('$label coming soon', context, AppColors.primary);
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await appAlertDialog(
      context,
      'Are you sure you want to logout?',
      title: 'Logout',
      actionButtonTitle: 'Logout',
      cancelButtonTitle: 'Cancel',
    );
    if (confirmed == true && context.mounted) {
      await bloc.logout(context);
    }
  }
}
