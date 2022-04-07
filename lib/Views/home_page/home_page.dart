import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/Components/drag_scroll.dart';
import '/Components/vertical_drag_divider.dart';
import '/Components/tab_bar_page_view.dart';

import '/Views/source_code/source_code_view.dart';
import '/Views/tokens/tokens_view.dart';
import '/Views/syntax_tree/syntax_tree_view.dart';

import '/Controllers/tiny_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int percision = 10000;
  int leftRightScrollFractionalPosition = (0.6 * percision).toInt();
  late Size sz;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sz = MediaQuery.of(context).size;
  }

  void onDrag({required double dx, required double dy}) {
    setState(() {
      leftRightScrollFractionalPosition += (dx / sz.width * percision).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: const Text("🧑‍💻 Tiny Scanner"),
        elevation: 0,
        actions: [
          Selector<TinyController, bool>(
            selector: (_, con) => con.ready,
            builder: (_, ready, child) => SizedBox(
              width: 80,
              child: IconButton(
                constraints: const BoxConstraints(minWidth: 80),
                icon: const Icon(Icons.play_arrow_rounded),
                tooltip: "Play scanner",
                onPressed: ready
                    ? context.read<TinyController>().scanSourceCode
                    : null,
              ),
            ),
          ),
          Selector<TinyController, bool>(
            selector: (_, con) => con.isLoadingFile,
            builder: (_, isLoadingFile, child) => SizedBox(
              width: 80,
              child: isLoadingFile
                  ? const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : IconButton(
                      constraints: const BoxConstraints(minWidth: 80),
                      icon: const Icon(Icons.insert_drive_file),
                      tooltip: "Pick source code file",
                      onPressed:
                          context.read<TinyController>().loadSourceCodeFile,
                    ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: leftRightScrollFractionalPosition,
            child: const SourceCodeView(),
          ),
          DragScroll(
            onDrag: onDrag,
            child: const VerticalDragDivider(),
          ),
          Expanded(
            flex: percision - leftRightScrollFractionalPosition,
            child: TabBarPageView(
              tabBarHeight: 40,
              tabs: const [
                Tab(
                  text: "Tokens",
                ),
                Tab(
                  text: "Syntax Tree",
                ),
              ],
              pages: const [
                TokensView(),
                SyntaxTreeView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
