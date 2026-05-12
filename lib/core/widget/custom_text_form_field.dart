import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:place_finder_app/core/widget/small_text.dart';

import '../theme/theme.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? suffixIcon;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextStyle? hintStyle;
  final bool obscureText;
  final TextStyle? labelStyle;
  final bool readOnly;
  final OutlineInputBorder? border;
  final int maxLines;
  final Function()? onPressed;
  final bool showBorder;
  final bool? isStar;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;

  const CustomTextFormField({
    this.onChanged,
    super.key,
    this.prefixText,
    required this.controller,
    this.labelText,
    this.hintText,
    this.suffixIcon,
    this.onPressed,
    this.hintStyle,
    this.border,
    this.labelStyle,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.showBorder = true,
    this.isStar = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              SmallText(
                text: labelText!,
                textColor: Colors.black,
                size: 12,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 5),
              if (validator != null && isStar == true)
                Icon(Icons.ac_unit, size: 10, color: Colors.red),
            ],
          ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onPressed,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.darkGrey),
          decoration: InputDecoration(
            prefixText: prefixText,
            prefixStyle: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w500,
            ),
            labelStyle: labelStyle,
            hintText: hintText,
            hintStyle: hintStyle,
            alignLabelWithHint: true,
            isCollapsed: false,
            suffixIcon: suffixIcon != null
                ? IconButton(
              onPressed: onPressed,
              icon: Icon(suffixIcon, color: AppTheme.smallText),
            )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),

            border: showBorder
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: const BorderSide(color: AppTheme.greyButton),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide.none,
            ),
            enabledBorder: showBorder
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: const BorderSide(color: AppTheme.greyButton),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide.none,
            ),
            focusedBorder: showBorder
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: const BorderSide(color: AppTheme.greyButton),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
