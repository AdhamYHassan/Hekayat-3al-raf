import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_app/core/theming/colors_manager.dart';
import 'package:base_app/core/theming/styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final String? hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final EdgeInsetsGeometry? padding;
  final String? validationMessage;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? height;
  final double? vertical;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final Color? borderColor;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? readOnly;
  final bool? enableInteractiveSelection;
  final VoidCallback? onTap;
  final BoxConstraints? boxConstraints;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.hintStyle,
    this.hintText,
    this.suffixIcon,
    this.labelText,
    this.obscureText,
    this.validationMessage,
    this.controller,
    this.onChanged,
    this.prefixIcon,
    this.padding,
    this.width,
    this.height,
    this.fillColor,
    this.keyboardType,
    this.borderColor,
    this.readOnly = false,
    this.enableInteractiveSelection,
    this.onTap,
    this.vertical,
    this.boxConstraints,
    this.validator,
    this.initialValue,
    this.isRequired = false,
    this.inputFormatters,
    this.style,
    this.textAlign,
    this.textAlignVertical,
  });

  @override
  Widget build(BuildContext context) {
    // Shared styling properties inherited from the dropdown theme
    final double defaultRadius = 10.r;
    final Color defaultBorderColor =
        borderColor ?? ColorManager.getBorder(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: 0.w,
              bottom: 8.h,
            ), // Matched 8.h spacing with dropdown
            child: RichText(
              text: TextSpan(
                text: labelText?.tr() ?? '',
                style: TextStyles.font14WhiteMedium.copyWith(
                  color: ColorManager.getText(
                    context,
                  ), // Replaced hardcoded black with dynamic text color
                ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyles.font14WhiteMedium.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ),
        Container(
          width: width ?? 331.w,
          height: height ?? 60.h,
          constraints: boxConstraints,
          child: TextFormField(
            cursorColor: ColorManager.orange,
            textAlign: textAlign ?? TextAlign.start,
            textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
            style:
                style ??
                TextStyles.font14WhiteMedium.copyWith(
                  color: ColorManager.getText(
                    context,
                  ), // Matches dropdown headerStyle
                ),
            keyboardType: keyboardType,
            controller: controller,
            maxLines: height != null ? null : 1,
            expands: height != null,
            readOnly: readOnly ?? false,
            enableInteractiveSelection: enableInteractiveSelection,
            initialValue: initialValue,
            onTap: onTap,
            autovalidateMode: AutovalidateMode.disabled,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  padding ??
                  EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: vertical ?? 14.h,
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
                borderSide: BorderSide(color: defaultBorderColor, width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
                borderSide: BorderSide(color: defaultBorderColor, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
                borderSide: BorderSide(color: defaultBorderColor, width: 1.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
                borderSide: BorderSide(color: Colors.red, width: 1.w),
              ),
              prefixIcon: prefixIcon,
              alignLabelWithHint: true,
              hintText: hintText?.tr(),
              hintStyle:
                  hintStyle ??
                  TextStyles.font14WhiteMedium.copyWith(
                    color: ColorManager.getTextMuted(
                      context,
                    ), // Matches dropdown hintStyle
                  ),
              suffixIcon: suffixIcon,
              fillColor:
                  fillColor ??
                  ColorManager.getCard(context), // Matches closedFillColor
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            obscureText: obscureText ?? false,
            onChanged: onChanged,
            validator: validator,
            inputFormatters: inputFormatters,
          ),
        ),
      ],
    );
  }

  factory AppTextField.userName({
    required TextEditingController userController,
  }) {
    return AppTextField(
      controller: userController,
      labelText: 'Username',
      validationMessage: 'Please enter your userName',
    );
  }

  factory AppTextField.password({
    required VoidCallback onToggleObscure,
    required bool isObscure,
    required TextEditingController passwordController,
  }) {
    return AppTextField(
      controller: passwordController,
      validationMessage: 'Please enter your password',
      labelText: 'Password',
      obscureText: isObscure,
      suffixIcon: IconButton(
        onPressed: onToggleObscure,
        icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
      ),
    );
  }
}
