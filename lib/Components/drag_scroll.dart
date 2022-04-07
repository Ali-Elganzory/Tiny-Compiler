import 'package:flutter/material.dart';

typedef OnDrag = void Function({required double dx, required double dy});

/// For scrolling a widget by exposing the [onDrag] callback with the dragged values [dx] and [dy]
/// in the horizontal and vertical axes, respectively.
class DragScroll extends StatefulWidget {
  const DragScroll({
    Key? key,
    required this.child,
    required this.onDrag,
  }) : super(key: key);

  final Widget child;
  final OnDrag onDrag;

  @override
  _DragScrollState createState() => _DragScrollState();
}

class _DragScrollState extends State<DragScroll> {
  double initialX = 0;
  double initialY = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onPanStart: (dragDetails) {
          initialX = dragDetails.globalPosition.dx;
          initialY = dragDetails.globalPosition.dy;
        },
        onPanUpdate: (dragDetails) {
          widget.onDrag(
            dx: dragDetails.globalPosition.dx - initialX,
            dy: dragDetails.globalPosition.dy - initialY,
          );
          initialX = dragDetails.globalPosition.dx;
          initialY = dragDetails.globalPosition.dy;
        },
        child: widget.child,
      ),
    );
  }
}
