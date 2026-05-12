import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final TextOverflow overflow;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;
  final TextDecoration? decoration;
  final int? maxLine;

  const BigText({
    super.key,
    this.color,
    this.decoration,
    required this.text,
    this.overflow = TextOverflow.ellipsis,
    this.size = 20,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.left,
    this.padding = const EdgeInsets.all(0),
    this.maxLine=2,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Text(
            text,
            softWrap: true,
            maxLines: maxLine,
            overflow: overflow,
            textAlign: textAlign,
            style: GoogleFonts.poppins(
                color: color ?? AppTheme.bigText,
                fontSize: size,
                fontWeight: fontWeight,
                decoration: decoration,
                decorationColor: AppTheme.secondaryColor
            ),
          );
        },
      ),
    );
  }
}
