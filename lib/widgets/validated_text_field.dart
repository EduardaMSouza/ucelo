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
  bool _focused = false;
  bool _valid = false;
  String? _error;

  void _runValidation(String value) {
    final err = widget.validator(value);

    setState(() {
      _error = err;
      _valid = err == null && value.isNotEmpty;
    });
  }

  Color _outlineColor() {
    if (_error != null) return Colors.red.shade400;
    if (_valid) return Colors.green.shade400;
    if (_focused) return const Color(0xFF4A90A4);
    return Colors.transparent;
  }

  Icon? _suffixIcon() {
    if (_error != null) {
      return Icon(Icons.error, size: 20, color: Colors.red.shade400);
    }
    if (_valid && !widget.obscureText) {
      return Icon(Icons.check_circle, size: 20, color: Colors.green.shade400);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: _outlineColor(), width: 2),
            boxShadow: [
              BoxShadow(
                color: _error != null
                    ? Colors.red.shade100
                    : _valid
                    ? Colors.green.shade100
                    : Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,

            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                widget.icon,
                color: _error != null
                    ? Colors.red.shade400
                    : _valid
                    ? Colors.green.shade400
                    : const Color(0xFF4A90A4),
              ),
              suffixIcon: _suffixIcon(),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),

            onChanged: (value) {
              _runValidation(value);
              widget.onChanged?.call(value);
            },

            onTap: () => setState(() => _focused = true),
            onEditingComplete: () => setState(() => _focused = false),
            onFieldSubmitted: widget.onFieldSubmitted,
          ),
        ),

        AnimatedErrorMessage(
          message: _error ?? '',
          show: _error != null,
        ),
      ],
    );
  }
}
