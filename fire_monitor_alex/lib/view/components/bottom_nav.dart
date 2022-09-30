import 'package:flutter/material.dart';
import 'button_nav_bar.dart';

typedef CustomCallback = void Function(int);

class BottomNavBar extends StatefulWidget {
  const BottomNavBar(
      {Key? key, required this.pageIndex, required this.changePageCallback})
      : super(key: key);

  final CustomCallback changePageCallback;
  final int pageIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void customRx(int i) {
    widget.changePageCallback(i);
  }

  static const bool testPlainColor = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 75,
      constraints: const BoxConstraints(maxHeight: 60),
      decoration: testPlainColor
          ? const BoxDecoration(
              color: Color.fromARGB(255, 19, 19, 19),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            )
          : const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(200, 46, 46, 46),
                  Color.fromARGB(255, 0, 0, 0),
                ],
              ),
            ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonNavBar(
                pageIndex: widget.pageIndex,
                id: 0,
                iconWhenSelected: Icons.map_outlined,
                iconWhenIdle: Icons.map_outlined,
                buttonPressedCallback: customRx,
              ),
              ButtonNavBar(
                pageIndex: widget.pageIndex,
                id: 1,
                iconWhenSelected: Icons.manage_search_outlined,
                iconWhenIdle: Icons.manage_search_outlined,
                buttonPressedCallback: customRx,
              ),
              ButtonNavBar(
                pageIndex: widget.pageIndex,
                id: 2,
                iconWhenSelected: Icons.info_outline,
                iconWhenIdle: Icons.info_outline,
                buttonPressedCallback: customRx,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
