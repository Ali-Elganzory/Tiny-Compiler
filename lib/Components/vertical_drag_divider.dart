import 'package:flutter/material.dart';

class VerticalDragDivider extends StatelessWidget {
  const VerticalDragDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Container(
        color: Colors.orange.shade200,
        alignment: Alignment.center,
        width: 6,
        child: Image.asset(
          "assets/images/dots_vert.png",
          width: 3,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
