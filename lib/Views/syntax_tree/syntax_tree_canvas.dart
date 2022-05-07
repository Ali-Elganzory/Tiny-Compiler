import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
import '/Models/syntax_tree.dart';

class SyntaxTreeCanvas extends StatefulWidget {
  const SyntaxTreeCanvas({
    Key? key,
    required this.syntaxTree,
  }) : super(key: key);

  final SyntaxTreeNode syntaxTree;

  @override
  State<SyntaxTreeCanvas> createState() => _SyntaxTreeCanvasState();
}

class _SyntaxTreeCanvasState extends State<SyntaxTreeCanvas> {
  Offset offset = const Offset(0, 0);
  double zoom = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            setState(() {
              zoom -= event.scrollDelta.dy.sign * 0.2;
              zoom = zoom.clamp(0.2, 10);
            });
          }
        },
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() => offset += details.delta);
          },
          child: CustomPaint(
            painter: _SyntaxTreePainter(
              syntaxTree: widget.syntaxTree,
              offset: offset,
              scale: zoom,
            ),
          ),
        ),
      ),
    );
  }
}

class _SyntaxTreePainter extends CustomPainter {
  _SyntaxTreePainter({
    required this.syntaxTree,
    required this.offset,
    required this.scale,
  });

  final SyntaxTreeNode syntaxTree;
  final Offset offset;
  final double scale;

  // Config
  static const radius = 24.0;
  static const diameter = 2 * radius;
  static const levelHeight = 2 * diameter;

  @override
  void paint(Canvas canvas, Size size) {
    // POV.
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale, scale);

    // Paint.
    final paint = Paint()
      ..color = Constants.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw nodes recursively.
    void drawNode(SyntaxTreeNode node, Offset center) {
      // Draw this node.
      canvas.drawCircle(center, radius, paint);
      canvas.drawText(node.token.value.toString(), center);

      // Then its children.
      // First, calculate the needed horizontal space.
      final horizontalSpace = node.dDescendentsCount * diameter * 1.1;

      // Second, flex each child according to its
      // descendents percentage of all node's descendents.
      var consumedSpace = 0.0;
      for (final child in node.children) {
        final childHorizontalSpace =
            ((child.dDescendentsCount + 1) / node.dDescendentsCount) *
                horizontalSpace;

        final offset = Offset(
          /* start after consumed space */ consumedSpace /* flex */ +
              childHorizontalSpace / 2 /* center under parent */ -
              (horizontalSpace / 2),
          levelHeight,
        );

        final childCenter = center + offset;

        // Draw child.
        drawNode(child, childCenter);

        // Draw the arrow to child.
        canvas.drawLine(center + const Offset(0, radius),
            childCenter - const Offset(0, radius), paint);

        // Update consumed space.
        consumedSpace += childHorizontalSpace;
      }
    }

    // Start.
    drawNode(syntaxTree, Offset(size.width / 2, 60));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension DrawText on Canvas {
  void drawText(String text, Offset center) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: 40,
    );

    textPainter.paint(
      this,
      (center - Offset(textPainter.width, textPainter.height) / 2),
    );
  }
}
