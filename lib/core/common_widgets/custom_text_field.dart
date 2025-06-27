import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final String? hintText;
  final String? labelText;
  final Widget? label;
  final TextInputType? textInputType;
  final Widget? prefix;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffix;
  final TextStyle? cursorTextStyle;
  final double? cursorHeight;
  final Color? cursorColor;
  final double? width;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final bool autoFocus;
  final bool readOnly;
  final bool? filled;
  final Color? fillColor;
  final bool? isDense;
  final bool isCollapsed;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final double outlineBorderRadius;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final bool isOutlinedInputBorder;
  final bool isunderlinedInputBorder;
  final bool obscureText;
  final String obscuringCharacter;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool? alignLabelWithHint;
  final List<BoxShadow>? boxShadow;

  const CustomTextField({
    super.key,
    this.controller,
    this.inputFormatters,
    this.maxLines = 1,
    this.hintText,
    this.labelText,
    this.label,
    this.textInputType,
    this.prefix,
    this.prefixIconConstraints,
    this.suffix,
    this.width,
    this.cursorTextStyle = const TextStyle(
      fontSize: 16,
    ),
    this.cursorHeight,
    this.cursorColor = Colors.grey,
    this.padding = const EdgeInsets.all(12),
    this.autoFocus = false,
    this.readOnly = false,
    this.filled = false,
    this.fillColor,
    this.isDense = true,
    this.isCollapsed = false,
    this.hintTextStyle = const TextStyle(
      fontSize: 16,
    ),
    this.labelTextStyle = const TextStyle(
      fontSize: 16,
    ),
    this.enabledBorder = const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    this.enabledBorderColor = Colors.transparent,
    this.focusedBorderColor = Colors.transparent,
    this.outlineBorderRadius = 8,
    this.isOutlinedInputBorder = false,
    this.isunderlinedInputBorder = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.borderWidth = 1.0,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.floatingLabelAlignment,
    this.floatingLabelBehavior,
    this.alignLabelWithHint,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(outlineBorderRadius),
        boxShadow: boxShadow,
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        maxLines: maxLines,
        autofocus: autoFocus,
        cursorColor: cursorColor,
        style: cursorTextStyle,
        cursorHeight: cursorHeight,
        validator: validator,
        onChanged: onChanged,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: padding,
          filled: filled,
          fillColor: fillColor,
          enabledBorder: isOutlinedInputBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: enabledBorderColor!,
                    width: borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(outlineBorderRadius),
                )
              : isunderlinedInputBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: enabledBorderColor!,
                        width: borderWidth,
                      ),
                    )
                  : enabledBorder,
          focusedBorder: isOutlinedInputBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: focusedBorderColor!,
                    width: borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(outlineBorderRadius),
                )
              : isunderlinedInputBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: focusedBorderColor!,
                        width: borderWidth,
                      ),
                    )
                  : focusedBorder,
          isDense: isDense,
          isCollapsed: isCollapsed,
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hintText,
          hintStyle: hintTextStyle,
          labelText: labelText,
          labelStyle: labelTextStyle,
          label: label,
          floatingLabelAlignment: floatingLabelAlignment,
          floatingLabelBehavior: floatingLabelBehavior,
          alignLabelWithHint: alignLabelWithHint,
          prefixIconConstraints: prefixIconConstraints,
        ),
      ),
    );
  }
}
