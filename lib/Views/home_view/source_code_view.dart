import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tiny_compiler/Controllers/tiny_controller.dart';

class SourceCodeView extends StatelessWidget {
  const SourceCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
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
                  style: TextStyle(fontWeight: FontWeight.w600),
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Selector<TinyController, String>(
                selector: (_, con) => con.sourceCode,
                builder: (_, sourceCode, child) => sourceCode.trim().isEmpty
                    ? Center(child: Text("The source code file is empty."))
                    : SelectableText.rich(
                        TextSpan(
                          text: sourceCode,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
