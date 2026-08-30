import 'package:flutter/material.dart';

import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/login_bloc/login_bloc_model.dart';
import '../../utils/constants/colors.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.bloc,
    required this.model,
    required this.emailController,
    required this.passwordController,
  });

  final LoginBloc bloc;
  final LoginBlocModel model;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sign in',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Use your teacher account',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey.shade400,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 22),
          _LoginField(
            controller: emailController,
            hintText: 'Email',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            onChanged: bloc.updateEmail,
          ),
          const SizedBox(height: 14),
          _LoginField(
            controller: passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: model.obscurePassword,
            textInputAction: TextInputAction.done,
            onChanged: bloc.updatePassword,
            suffixIcon: IconButton(
              onPressed: bloc.toggleObscure,
              icon: Icon(
                model.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade500,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: model.isLoading ? null : () => bloc.login(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.loginGreen,
                disabledBackgroundColor: AppColors.loginGreen.withValues(alpha: 0.5),
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: model.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final ValueChanged<String?> onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade400, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.loginGreen, width: 1.4),
        ),
      ),
    );
  }
}
