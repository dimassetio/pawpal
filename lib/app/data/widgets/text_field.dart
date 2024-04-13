import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class PPTextfield extends StatelessWidget {
  PPTextfield({
    this.textFieldType = TextFieldType.NAME,
    this.controller,
    this.isValidationRequired = true,
    this.isZeroPadding = true,
    this.isEnabled,
    this.isReadOnly = false,
    this.digitsOnly,
    this.icon,
    this.isBordered = false,
    this.label,
    this.initValue,
    this.hint,
    this.suffixColor,
    this.maxLine,
    this.borderRadius,
    this.inputFormatters,
    this.suffixIcon,
    this.validator,
    this.onTap,
    this.padding,
    this.fillColor,
  });
  final TextFieldType textFieldType;
  final TextEditingController? controller;
  final bool isValidationRequired;
  final bool isZeroPadding;
  final bool? isEnabled;
  final bool isReadOnly;
  final bool? digitsOnly;
  final Icon? icon;
  final bool isBordered;
  final String? label;
  final String? initValue;
  final String? hint;
  final Color? suffixColor;
  final int? maxLine;
  final double? borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      onTap: onTap,
      controller: controller,
      isValidationRequired: isValidationRequired,
      maxLines: maxLine,
      inputFormatters: inputFormatters ??
          ((digitsOnly ?? false)
              ? [FilteringTextInputFormatter.digitsOnly]
              : null),
      textFieldType: textFieldType,
      decoration: InputDecoration(
        contentPadding: padding ?? (isZeroPadding ? EdgeInsets.zero : null),
        prefixIcon: icon,
        border: isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 100))
            : null,
        filled: fillColor is Color,
        fillColor: fillColor,
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixColor,
      ),
      enabled: isEnabled,
      readOnly: isReadOnly,
      validator: validator,
      initialValue: initValue,
    );
  }
}
