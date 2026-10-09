import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/colores.dart';

class CodeInput extends StatefulWidget {
  final int length;
  final double height;
  final ValueChanged<String> onChanged;

  const CodeInput({
    super.key,
    required this.length,
    required this.height,
    required this.onChanged,
  });

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (
        var offset = 0;
        offset < digits.length && index + offset < widget.length;
        offset++
      ) {
        _controllers[index + offset].text = digits[offset];
      }
      final nextIndex = (index + digits.length)
          .clamp(0, widget.length - 1)
          .toInt();
      _focusNodes[nextIndex].requestFocus();
    } else if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    widget.onChanged(_controllers.map((controller) => controller.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == widget.length - 1 ? 0 : 8),
            child: SizedBox(
              height: widget.height,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  color: Colores.negro,
                  fontSize: 22,
                  fontFamily: 'Poly',
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colores.blanco.withValues(alpha: 0.9),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colores.azulSecundario.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colores.azulSecundario.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colores.azulSecundario,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => _handleChanged(index, value),
              ),
            ),
          ),
        );
      }),
    );
  }
}
