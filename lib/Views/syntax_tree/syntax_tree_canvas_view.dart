import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/Controllers/tiny_controller.dart';
import '/Models/syntax_tree.dart';

import './syntax_tree_canvas.dart';

class SyntaxTreeCanvasView extends StatelessWidget {
  const SyntaxTreeCanvasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(
        minWidth: double.maxFinite,
        minHeight: double.maxFinite,
      ),
      child: Selector<TinyController, bool>(
        selector: (_, con) => con.hasParseError,
        builder: (_, hasParseError, child) => hasParseError
            ? Center(child: Text(context.read<TinyController>().parseError))
            : Selector<TinyController, SyntaxTreeNode?>(
                selector: (_, con) => con.syntaxTree,
                builder: (_, syntaxTree, child) => syntaxTree == null
                    ? const Center(
                        child: Text("No parse tree yet 🥺"),
                      )
                    : SyntaxTreeCanvas(syntaxTree: syntaxTree),
              ),
      ),
    );
  }
}
