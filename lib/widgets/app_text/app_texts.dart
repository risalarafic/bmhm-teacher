import 'package:flutter/material.dart';

import '../../utils/common_methods.dart';
import '../../utils/constants/colors.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.textType = TextWeight.regular,
    this.size,
    this.color = AppColors.black,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });

  final String text;
  final TextWeight textType;
  final double? size;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: getFontWeight(textType),
      ),
    );
  }
}
