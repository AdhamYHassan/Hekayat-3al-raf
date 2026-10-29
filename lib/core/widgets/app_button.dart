import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_app/core/theming/colors_manager.dart';
import 'package:base_app/core/theming/styles.dart';

class AppButton extends StatelessWidget {
  final double? buttonWidth;
  final double? buttonHeight;
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  final VoidCallback? onPressed;
  final WidgetStateProperty<Color?>? backgroundColor;
  final String buttonText;
  final TextStyle? buttonTextStyle;
  final Color? borderColor;
  final String? svg;
  final String? rightSvg;
  final IconData? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    this.buttonWidth,
    this.buttonHeight,
    this.onPressed,
    this.usernameController,
    this.passwordController,
    required this.buttonText,
    this.backgroundColor,
    this.buttonTextStyle,
    this.borderColor,
    this.svg,
    this.rightSvg,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final Color contentColor = isEnabled ? Colors.white : Colors.white70;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor:
            backgroundColor ??
            WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey;
              }
              return ColorManager.orange;
            }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 8.0.h),
        ),
        fixedSize: WidgetStateProperty.all(
          Size(buttonWidth?.w ?? double.maxFinite, buttonHeight?.h ?? 38.h),
        ),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
          final bool isEnabled = !states.contains(WidgetState.disabled);
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color:
                  borderColor ??
                  (isEnabled ? ColorManager.primary : Colors.grey),
              width: (borderColor != null || !isEnabled) ? 1.0 : 0,
            ),
          );
        }),
      ),
      child: isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.h,
              child: CircularProgressIndicator(
                color: contentColor,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (svg != null)
                  Padding(
                    padding: EdgeInsets.only(right: 5.w, left: 5.w),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isEnabled
                            ? Colors.transparent
                            : Colors.grey.withValues(alpha: 0.5),
                        BlendMode.srcATop,
                      ),
                      child: SvgPicture.asset(
                        svg ?? '',
                        width: 14.5,
                        height: 15.h,
                      ),
                    ),
                  ),
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Icon(icon, color: contentColor, size: 20.sp),
                  ),
                FittedBox(
                  child: Text(
                    buttonText,
                    style:
                        (buttonTextStyle ??
                                TextStyles.font16WhiteBold.copyWith(
                                  fontWeight: FontWeight.w500,
                                ))
                            .copyWith(
                              color: buttonTextStyle?.color != null
                                  ? (isEnabled
                                        ? buttonTextStyle!.color
                                        : buttonTextStyle!.color!.withValues(
                                            alpha: 0.5,
                                          ))
                                  : contentColor,
                            ),
                  ),
                ),
                if (rightSvg != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isEnabled
                            ? Colors.transparent
                            : Colors.grey.withValues(alpha: 0.5),
                        BlendMode.srcATop,
                      ),
                      child: SvgPicture.asset(
                        rightSvg ?? '',
                        width: 10.5,
                        height: 10.h,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
