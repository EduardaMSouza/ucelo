import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'animated_error_message.dart';

class ValidatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const ValidatedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  bool _hasError = false;
  String? _errorMessage;
  bool _isValid = false;
  bool _isFocused = false;

  void _validate([String? value]) {
    final textToValidate = value ?? widget.controller.text;
    final error = widget.validator(textToValidate);
    setState(() {
      _hasError = error != null;
      _errorMessage = error;
      _isValid = !_hasError && textToValidate.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: _hasError
                ? Border.all(color: Colors.red.shade400, width: 2)
                : _isValid
                    ? Border.all(color: Colors.green.shade400, width: 2)
                    : _isFocused
                        ? Border.all(color: const Color(0xFF4A90A4), width: 2)
                        : null,
            boxShadow: [
              BoxShadow(
                color: _hasError
                    ? Colors.red.shade100
                    : _isValid
                        ? Colors.green.shade100
                        : Colors.black.withValues(alpha: 0.1),
                blurRadius: _hasError || _isValid ? 8 : 10,
                offset: const Offset(0, 5),
                spreadRadius: _hasError || _isValid ? 1 : 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _hasError
                    ? Colors.red.shade400
                    : _isValid
                        ? Colors.green.shade400
                        : const Color(0xFF4A90A4),
              ),
              suffixIcon: _isValid && !widget.obscureText
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green.shade400,
                      size: 20,
                    )
                  : _hasError
                      ? Icon(
                          Icons.error,
                          color: Colors.red.shade400,
                          size: 20,
                        )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            validator: (value) {
              _validate(value);
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              _validate(value);
              widget.onChanged?.call(value);
            },
            onTap: () {
              setState(() => _isFocused = true);
            },
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: () {
              setState(() => _isFocused = false);
            },
          ),
        ),
        AnimatedErrorMessage(
          message: _errorMessage ?? '',
          show: _hasError,
        ),
      ],
    );
  }
}

