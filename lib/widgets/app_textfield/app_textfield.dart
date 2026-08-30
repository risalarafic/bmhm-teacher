import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/common_methods.dart';
import '../../utils/constants/colors.dart';
import '../app_text/app_texts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    required this.titleText,
    required this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.controller,
  });

  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final String titleText;
  final ValueChanged<String?> onChanged;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(titleText, size: 12, color: AppColors.grey, textType: TextWeight.light),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.fieldBg,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
