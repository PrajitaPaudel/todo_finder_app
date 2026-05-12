
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/theme.dart';

class SmallText extends StatelessWidget {
  final Color? textColor;
  final String text;
  final double size;
  final double height;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  const SmallText({
    super.key,
    this.textColor,
    required this.text,
    this.height = 1.5,
    this.padding,
    this.size = 12,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        maxLines: 5,
        textAlign: textAlign,
        style: GoogleFonts.poppins(
          color: textColor ?? AppTheme.smallText,
          fontSize: size,
          fontWeight: fontWeight,
          height: height,
        ),
      ),
    );
  }
}
