import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:tiny_compiler/Components/drag_scroll.dart';
import 'package:tiny_compiler/Components/vertical_drag_divider.dart';
import 'package:tiny_compiler/Controllers/tiny_controller.dart';
import 'package:tiny_compiler/Views/home_view/source_code_view.dart';
import 'package:tiny_compiler/Views/home_view/tokens_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
        title: Text("  😸    Tiny Scanner"),
        actions: [
          Selector<TinyController, bool>(
            selector: (_, con) => con.ready,
            builder: (_, ready, child) => SizedBox(
              width: 80,
              child: IconButton(
                constraints: BoxConstraints(minWidth: 80),
                icon: Icon(Icons.play_arrow_rounded),
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
                  ? Center(child: CircularProgressIndicator())
                  : IconButton(
                      constraints: BoxConstraints(minWidth: 80),
                      icon: Icon(Icons.insert_drive_file),
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
            child: const TokensView(),
          ),
        ],
      ),
    );
  }
}
