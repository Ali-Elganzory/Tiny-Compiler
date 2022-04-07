import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import './/constants.dart';

class TabBarPageView extends StatefulWidget {
  const TabBarPageView({
    Key? key,
    this.tabBarHeight = kToolbarHeight,
    required this.tabs,
    required this.pages,
  })  : assert(tabs.length > 0),
        assert(pages.length > 0),
        assert(tabs.length == pages.length),
        super(key: key);

  final double tabBarHeight;
  final List<Tab> tabs;
  final List<Widget> pages;

  @override
  State<TabBarPageView> createState() => _TabBarPageViewState();
}

class _TabBarPageViewState extends State<TabBarPageView> {
  int _selectedPageIndex = 0;
  int get selectedPageIndex => _selectedPageIndex;
  set selectedPageIndex(int i) {
    if (i < widget.pages.length && i != selectedPageIndex) {
      setState(() {
        _selectedPageIndex = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.tabBarHeight,
          width: double.maxFinite,
          color: Constants.accent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.tabs
                .mapIndexed<Widget>(
                  (i, e) => Expanded(
                    child: InkWell(
                        onTap: () {
                          selectedPageIndex = i;
                        },
                        child: AnimatedContainer(
                          child: Text(
                            e.text ?? "",
                            style: selectedPageIndex == i
                                ? null
                                : const TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(milliseconds: 150),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: selectedPageIndex == i
                              ? const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  color: Colors.white,
                                )
                              : const BoxDecoration(
                                  color: Color(0x00FFFFFF),
                                ),
                        )),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: widget.pages[selectedPageIndex],
        ),
      ],
    );
  }
}
