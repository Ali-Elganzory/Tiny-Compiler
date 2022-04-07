import 'package:flutter/material.dart';

import '/Models/syntax_tree.dart';

class SyntaxTreeText extends StatelessWidget {
  const SyntaxTreeText({
    Key? key,
    required this.syntaxTree,
  }) : super(key: key);

  final SyntaxTreeNode syntaxTree;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Text(syntaxTree.asString()),
    );
  }
}

extension AsString on SyntaxTreeNode {
  String asString([int level = 1]) {
    return "$debugName: ${token.value}" +
        children
            .map<String>((e) => "\n" + "    " * level + e.asString(level + 1))
            .join();
  }
}
