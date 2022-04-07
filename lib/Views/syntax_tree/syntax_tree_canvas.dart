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
  static const minDistance = diameter;
  static const levelHeight = 2 * diameter;

  @override
  void paint(Canvas canvas, Size size) {
    // POV
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale, scale);

    // Painting
    final paint = Paint()
      ..color = Constants.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Drawing nodes
    void drawNode(SyntaxTreeNode node, Offset center) {
      canvas.drawCircle(center, radius, paint);
      canvas.drawText(node.token.value.toString(), center);

      final distance = pow(1.4, node.dReversedDepth) * minDistance;
      final List<Offset> childCenters = [
        center + Offset(-distance, levelHeight),
        center + const Offset(0, levelHeight),
        center + Offset(distance, levelHeight),
      ];
      // print("$childCenters  :::  $distance  :::  $center");

      switch (node.children.length) {
        case 1:
          canvas.drawLine(center + const Offset(0, radius),
              childCenters[1] - const Offset(0, radius), paint);
          drawNode(node.children[0], childCenters[1]);
          break;
        case 2:
          canvas.drawLine(center + const Offset(0, radius),
              childCenters[0] - const Offset(0, radius), paint);
          canvas.drawLine(center + const Offset(0, radius),
              childCenters[2] - const Offset(0, radius), paint);
          drawNode(node.children[0], childCenters[0]);
          drawNode(node.children[1], childCenters[2]);
          break;
        case 3:
          canvas.drawLine(center + const Offset(0, radius),
              childCenters[0] - const Offset(0, radius), paint);
          canvas.drawLine(center + const Offset(0, radius),
              childCenters[1] - const Offset(0, radius), paint);
          canvas.drawLine(center + const Offset(0, radius),
              childCenters[2] - const Offset(0, radius), paint);
          drawNode(node.children[0], childCenters[0]);
          drawNode(node.children[1], childCenters[1]);
          drawNode(node.children[2], childCenters[2]);
          break;
        default:
      }
    }

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
