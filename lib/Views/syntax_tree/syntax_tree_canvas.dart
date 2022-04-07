import 'package:flutter/material.dart';
import 'package:tiny_compiler/constants.dart';

import '/Models/syntax_tree.dart';

class SyntaxTreeCanvas extends StatelessWidget {
  const SyntaxTreeCanvas({
    Key? key,
    required this.syntaxTree,
  }) : super(key: key);

  final SyntaxTreeNode syntaxTree;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(painter: _SyntaxTreePainter(syntaxTree)),
    );
  }
}

class _SyntaxTreePainter extends CustomPainter {
  _SyntaxTreePainter(this.syntaxTree);

  final SyntaxTreeNode syntaxTree;

  @override
  void paint(Canvas canvas, Size size) {
    // Config
    const radius = 20.0;

    // Painting
    final paint = Paint()
      ..color = Constants.accent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(size.width / 2, 60), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
