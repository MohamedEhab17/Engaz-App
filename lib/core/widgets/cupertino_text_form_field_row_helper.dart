import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTextFormFieldHelper extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final bool isPassword;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool? isMobile;
  final bool showClearButton;

  final String? hint;
  final String? label;
  final String? initialValue;
  final String obscuringCharacter;

  final int? maxLines, minLines, maxLength;

  final String? Function(String?)? validator;
  final void Function(String?)? onChanged, onSubmitted, onSaved;
  final void Function()? onTap;

  final TextInputType? keyboardType;
  final TextInputAction? action;

  final Widget? prefix;
  final Widget? suffix;

  final Color? backgroundColor;
  final Color? borderColor;

  final double borderWidth;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final bool scrollEnabled;

  const CupertinoTextFormFieldHelper({
    super.key,
    this.controller,
    this.focusNode,
    this.isPassword = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.isMobile,
    this.showClearButton = true,
    this.hint,
    this.label,
    this.initialValue,
    this.obscuringCharacter = "*",
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
    this.onTap,
    this.keyboardType,
    this.action,
    this.prefix,
    this.suffix,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.height,
    this.borderRadius,
    this.scrollPadding = EdgeInsets.zero,
    this.scrollPhysics,
    this.scrollEnabled = false,
  });

  @override
  State<CupertinoTextFormFieldHelper> createState() =>
      _CupertinoTextFormFieldHelperState();
}

class _CupertinoTextFormFieldHelperState
    extends State<CupertinoTextFormFieldHelper> {
  late bool obscureText;
  String? errorMessage;
  TextDirection _textDirection = TextDirection.rtl;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null && widget.controller != null) {
        widget.controller!.text = widget.initialValue!;
        _updateDirection(widget.initialValue!);
      }
    });
  }

  void _updateDirection(String text) {
    if (text.trim().isEmpty) return;
    final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(text.trim());
    setState(
      () => _textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  void _toggleObscure() {
    setState(() => obscureText = !obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = widget.backgroundColor ?? const Color(0xFFF3F3F3);
    final Color borderClr = widget.borderColor ?? Colors.grey.shade400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 4),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: widget.height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(14),
            border: Border.all(
              color: errorMessage == null ? borderClr : Colors.red,
              width: widget.borderWidth,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            children: [
              if (widget.prefix != null) ...[
                widget.prefix!,
                const SizedBox(width: 6),
              ],

              Expanded(
                child: CupertinoTextFormFieldRow(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  placeholder: widget.hint,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus,
                  obscureText: obscureText,
                  obscuringCharacter: widget.obscuringCharacter,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.maxLength,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.action,
                  scrollPadding: widget.scrollPadding,
                  scrollPhysics: widget.scrollEnabled
                      ? (widget.scrollPhysics ?? const BouncingScrollPhysics())
                      : const NeverScrollableScrollPhysics(),

                  padding: EdgeInsets.zero,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: widget.isMobile != null
                      ? TextAlign.left
                      : TextAlign.start,
                  textDirection: widget.isMobile != null
                      ? TextDirection.ltr
                      : _textDirection,
                  onTap: widget.onTap,
                  onChanged: (txt) {
                    widget.onChanged?.call(txt);
                    errorMessage = widget.validator?.call(txt);
                    _updateDirection(txt);
                    setState(() {});
                  },
                  onFieldSubmitted: widget.onSubmitted,
                  onSaved: widget.onSaved,
                ),
              ),

              /// PASSWORD EYE
              if (widget.isPassword)
                GestureDetector(
                  onTap: _toggleObscure,
                  child: Icon(
                    obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),

              /// CUSTOM SUFFIX
              if (!widget.isPassword && widget.suffix != null) widget.suffix!,

              /// CLEAR BUTTON
              if (widget.showClearButton &&
                  widget.controller != null &&
                  widget.controller!.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    widget.controller!.clear();
                    widget.onChanged?.call("");
                    _updateDirection("");
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      CupertinoIcons.clear_circled,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),

        /// ERROR
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 4),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
