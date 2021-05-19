import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tiny_compiler/Controllers/tiny_controller.dart';
import 'package:tiny_compiler/Models/token.dart';

class TokensView extends StatelessWidget {
  const TokensView({Key? key}) : super(key: key);

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
            alignment: Alignment.center,
            color: Colors.orange.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              text: TextSpan(
                text: "Tokens",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Selector<TinyController, bool>(
                selector: (_, con) => con.isInvalidSourceCode,
                builder: (_, isInvalidSourceCode, child) => isInvalidSourceCode
                    ? Center(
                        child: Text(
                            "The source code has an error near ${context.read<TinyController>().invalidToken?.value}"))
                    : Selector<TinyController, List<Token>>(
                        selector: (_, con) => con.tokens,
                        builder: (_, tokens, child) => tokens.isEmpty
                            ? const Center(child: Text("No tokens 🥺"))
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "👌",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 20),
                                  Table(
                                    children: [
                                      const TableRow(
                                        decoration: BoxDecoration(
                                          color: Color(4294959282),
                                        ),
                                        children: [
                                          Text(
                                            "Class",
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Type",
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Value",
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      ...tokens.map<TableRow>(
                                        (token) => TableRow(
                                          children: [
                                            Text(token.runtimeType.toString()),
                                            Text(token.type
                                                .toString()
                                                .split('.')[1]),
                                            Text(token.value.toString()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
