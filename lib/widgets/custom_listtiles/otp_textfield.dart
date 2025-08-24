import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  final Color borderColor;
  final double fieldHeight;
  final double fieldWidth;
  final Color fillColor;
  final bool filled;
  final BorderRadius borderRadius;
  final Color disabledBorderColor;
  final Color focusedBorderColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle textStyle;
  final bool showFieldAsBox;
  final double borderWidth;
  final int length;
  final ValueChanged<String>? onCodeChanged;
  final ValueChanged<String>? onSubmit;
  final FocusNode? focusNode;
  final bool autoFocus;

  const OtpTextField({
    super.key,
    this.borderColor = Colors.grey,
    this.fieldHeight = 60,
    this.fieldWidth = 46,
    this.fillColor = Colors.transparent,
    this.filled = false,
    this.borderRadius = BorderRadius.zero,
    this.disabledBorderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    this.showFieldAsBox = true,
    this.borderWidth = 1.0,
    this.length = 6,
    this.onCodeChanged,
    this.onSubmit,
    this.focusNode,
    this.autoFocus = false,
  });

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChange(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    _updateOtpCode();
  }

  void _updateOtpCode() {
    final newCode = _controllers.map((c) => c.text).join();
    if (newCode != _otpCode) {
      _otpCode = newCode;
      widget.onCodeChanged?.call(_otpCode);
      if (_otpCode.length == widget.length) {
        widget.onSubmit?.call(_otpCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: List.generate(
        widget.length,
        (index) => Container(
          width: widget.fieldWidth,
          height: widget.fieldHeight,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: widget.filled ? widget.fillColor : null,
            borderRadius: widget.borderRadius,
          ),
          child: Center(
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              style: widget.textStyle,
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                filled: widget.filled,
                fillColor: widget.fillColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.disabledBorderColor,
                    width: widget.borderWidth,
                  ),
                  borderRadius: widget.borderRadius,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.focusedBorderColor,
                    width: widget.borderWidth,
                  ),
                  borderRadius: widget.borderRadius,
                ),
              ),
              onChanged: (value) => _handleTextChange(index, value),
            ),
          ),
        ),
      ),
    );
  }
}