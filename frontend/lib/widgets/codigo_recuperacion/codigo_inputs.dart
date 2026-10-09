import 'package:flutter/material.dart';
import '../common/code_input.dart';

class CodigoInputs extends StatelessWidget {
  final double width;
  final double height;
  final ValueChanged<String> onChanged;

  const CodigoInputs({
    super.key,
    required this.width,
    required this.height,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final boxHeight = height * 0.081;
    final top = height * 0.500;

    return Positioned(
      left: width * 0.063,
      right: width * 0.063,
      top: top,
      height: boxHeight,
      child: CodeInput(
        length: 6,
        height: boxHeight,
        onChanged: onChanged,
      ),
    );
  }
}
