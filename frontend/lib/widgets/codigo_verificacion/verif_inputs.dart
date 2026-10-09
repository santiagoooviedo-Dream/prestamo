import 'package:flutter/material.dart';
import '../common/code_input.dart';

class VerifInputs extends StatelessWidget {
  final double width;
  final double height;
  final ValueChanged<String> onChanged;

  const VerifInputs({
    super.key,
    required this.width,
    required this.height,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final boxH = height * 0.070;
    final top = height * 0.52;

    return Positioned(
      left: width * 0.08,
      right: width * 0.08,
      top: top,
      height: boxH,
      child: CodeInput(
        length: 6,
        height: boxH,
        onChanged: onChanged,
      ),
    );
  }
}
