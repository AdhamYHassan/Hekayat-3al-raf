import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/helpers/arabic_to_english_digits_formatter.dart';
import 'package:hekayat_3al_raf/core/helpers/digit_converter.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class SixDigitPinField extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const SixDigitPinField({
    super.key,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<SixDigitPinField> createState() => _SixDigitPinFieldState();
}

class _SixDigitPinFieldState extends State<SixDigitPinField> {
  static const int _codeLength = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentCode =>
      _controllers.map((c) => c.text).join();

  void _onFieldChanged(String value, int index) {
    if (value.length > 1) {
      // Handles pasting full 6 digits into any field
      final converted = DigitConverter.convertString(value);
      final clean = converted.replaceAll(RegExp(r'\D'), '');
      if (clean.length == _codeLength) {
        for (int i = 0; i < _codeLength; i++) {
          _controllers[i].text = clean[i];
        }
        _focusNodes.last.requestFocus();
        widget.onChanged?.call(clean);
        widget.onCompleted(clean);
        return;
      } else {
        // Keep only single character
        _controllers[index].text = clean.isNotEmpty ? clean.substring(0, 1) : '';
      }
    }

    widget.onChanged?.call(_currentCode);

    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_currentCode.length == _codeLength) {
      widget.onCompleted(_currentCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_codeLength, (index) {
            return SizedBox(
              width: 48.w,
              height: 54.h,
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: index == _codeLength - 1
                    ? TextInputAction.done
                    : TextInputAction.next,
                style: GoogleFonts.alexandria(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.goldLight,
                ),
                cursorColor: ColorManager.gold,
                inputFormatters: [
                  const ArabicToEnglishDigitsFormatter(),
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_codeLength),
                ],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: ColorManager.primaryLight.withValues(alpha: 0.45),
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: ColorManager.gold.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: ColorManager.gold,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (val) => _onFieldChanged(val, index),
              ),
            );
          }),
        ),
      ),
    );
  }
}
