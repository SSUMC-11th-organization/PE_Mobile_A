import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SignUpTextField extends StatefulWidget {
  const SignUpTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.compact = false,
    this.showVisibilityToggle = false,
    this.onFieldSubmitted,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;

  /// 넓은 화면용 스타일(작은 라벨, 연한 힌트 색)을 사용한다.
  final bool compact;

  /// 비밀번호 표시·숨김 버튼을 오른쪽 아이콘 자리에 보여준다.
  final bool showVisibilityToggle;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<SignUpTextField> createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  bool _edited = false;
  bool _obscured = true;

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    final hasError = _edited && widget.validator(text) != null;
    final isValid = text.isNotEmpty && widget.validator(text) == null;

    Widget? suffix;
    if (widget.showVisibilityToggle) {
      suffix = GestureDetector(
        onTap: () => setState(() => _obscured = !_obscured),
        child: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 22,
          color: AppColors.textPrimary,
        ),
      );
    } else if (hasError) {
      suffix = const Icon(
        Icons.error_outline,
        size: 20,
        color: AppColors.error,
      );
    } else if (isValid) {
      suffix = const Icon(
        Icons.check_circle,
        size: 20,
        color: AppColors.violet,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.compact
              ? AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary)
              : AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText && _obscured,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          onChanged: (_) => setState(() => _edited = true),
          onFieldSubmitted: widget.onFieldSubmitted,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.gray,
              fontWeight: FontWeight.w400,
            ),
            isDense: true,
            filled: true,
            fillColor: hasError
                ? AppColors.errorBackground
                : AppColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 9,
            ),
            suffixIcon: suffix == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: suffix,
                  ),
            suffixIconConstraints: const BoxConstraints(),
            errorStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              color: AppColors.error,
            ),
            enabledBorder: _border(AppColors.outline),
            focusedBorder: _border(AppColors.violet, width: 2),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 2),
          ),
        ),
      ],
    );
  }
}
