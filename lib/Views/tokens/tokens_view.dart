import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './/Controllers/tiny_controller.dart';
import './/Models/token.dart';

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
      child: Selector<TinyController, bool>(
        selector: (_, con) => con.isInvalidSourceCode,
        builder: (_, isInvalidSourceCode, child) => isInvalidSourceCode
            ? Center(
                child: Text(
                    "The source code has an error near ${context.read<TinyController>().invalidToken?.value}"))
            : Selector<TinyController, List<Token>>(
                selector: (_, con) => con.tokens,
                builder: (_, tokens, child) => tokens.isEmpty
                    ? const Center(child: Text("No tokens yet 🥺"))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
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
                                    color: Color(0xffffe0b2),
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
                                      Text(token.type.toString().split('.')[1]),
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
    );
  }
}
