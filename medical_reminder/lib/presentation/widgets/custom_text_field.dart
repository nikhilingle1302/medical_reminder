import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final IconData? prefixIconData;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool isRequired;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final bool enabled;
  final Function(String)? onChanged;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.prefixIconData,
    this.suffixIcon,
    this.isPassword = false,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onSubmitted,
    this.fillColor,
    this.borderColor,
    this.contentPadding,
    this.hintStyle,
    this.style,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (widget.labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: RichText(
              text: TextSpan(
                text: widget.labelText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                children: widget.isRequired
                    ? [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                          ),
                        ),
                      ]
                    : [],
              ),
            ),
          ),

        // Text Field
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onSubmitted,
          textCapitalization: widget.textCapitalization,
          style: widget.style ??
              TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
            filled: true,
            fillColor: widget.fillColor ??
                (widget.enabled ? const Color(0xFFF5F5F5) : Colors.grey.shade100),
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: widget.maxLines! > 1 ? 12.h : 0,
                ),
            prefixIcon: widget.prefixIcon ??
                (widget.prefixIconData != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 12.w),
                        child: Icon(
                          widget.prefixIconData,
                          size: 20.sp,
                          color: Colors.grey,
                        ),
                      )
                    : null),
            prefixIconConstraints: BoxConstraints(minWidth: 40.w),
            suffixIcon: widget.isPassword
                ? _buildPasswordVisibilityToggle()
                : widget.suffixIcon,
            suffixIconConstraints: BoxConstraints(minWidth: 40.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: widget.borderColor ?? Colors.transparent,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Color(0xFF2D9CDB),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            errorStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.red,
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget? _buildPasswordVisibilityToggle() {
    return widget.isPassword
        ? Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                size: 20.sp,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          )
        : null;
  }
}

// Search TextField Variant
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final Function()? onSearch;
  final bool autofocus;

  const SearchTextField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSearch,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: (_) => onSearch?.call(),
      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 12.w),
          child: Icon(Icons.search, size: 20.sp, color: Colors.grey),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, size: 20.sp, color: Colors.grey),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF2D9CDB), width: 2),
        ),
      ),
    );
  }
}

// Multiline TextField
class MultilineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final int minLines;
  final int maxLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const MultilineTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.minLines = 3,
    this.maxLines = 5,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              labelText!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: EdgeInsets.all(16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFF2D9CDB), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}