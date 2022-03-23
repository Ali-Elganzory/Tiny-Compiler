import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tiny_compiler/Controllers/tiny_controller.dart';

class SourceCodeView extends StatelessWidget {
  const SourceCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(
        minWidth: double.maxFinite,
        minHeight: double.maxFinite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: double.maxFinite,
            alignment: Alignment.centerLeft,
            color: Colors.orange.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Selector<TinyController, String>(
              selector: (_, con) => con.filePath,
              builder: (_, path, child) => RichText(
                text: TextSpan(
                  text: "File path: ",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: path,
                    )
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller:
                  context.read<TinyController>().sourceCodeEditorController,
              expands: true,
              minLines: null,
              maxLines: null,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
