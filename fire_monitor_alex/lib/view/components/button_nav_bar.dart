import 'package:flutter/material.dart';

typedef CustomCallback = void Function(int);

class ButtonNavBar extends StatelessWidget {
  const ButtonNavBar(
      {Key? key,
      required this.pageIndex,
      required this.id,
      required this.iconWhenSelected,
      required this.iconWhenIdle,
      required this.buttonPressedCallback})
      : super(key: key);

  final int pageIndex; //Page to be set
  final int id; //Id of the position of the button inside all the buttons
  final IconData
      iconWhenSelected; //Icon to be displayed when this page is active
  final IconData iconWhenIdle; //Icon to be displayed when this page is idle
  final CustomCallback buttonPressedCallback;

  static const double iconSize = 30;
  static const double dotSize = 6;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 0,
      children: [
        //const Text('Test text 1'),
        //const Text('This is my text 2'),
        IconButton(
          //Default size without constraints = 48 unidades cuadradas
          constraints: const BoxConstraints(
              maxHeight: 45, maxWidth: 30, minHeight: 40, minWidth: 30),
          padding: const EdgeInsets.fromLTRB(
              0, 10, 0, 0), //Esta inclos dins del Icon
          enableFeedback: false,
          onPressed: () {
            buttonPressedCallback(id);
          },
          icon: pageIndex ==
                  id //Set selected the button if the page where we are is the same to our id, elsewhere it is not this page
              ? Icon(
                  iconWhenSelected,
                  color: Colors.blue,
                  size: iconSize,
                )
              : Icon(
                  //Icons.work_rounded,
                  iconWhenIdle,
                  color: Colors.white,
                  size: iconSize,
                ),
        ),
        IconButton(
          constraints: const BoxConstraints(
              maxHeight: 20, maxWidth: 20, minHeight: 20, minWidth: 20),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
          alignment: Alignment.center,
          onPressed: () => {},
          icon: pageIndex == id
              ? const Icon(
                  Icons.circle_rounded,
                  color: Colors.blue,
                  size: dotSize,
                )
              : const Icon(
                  Icons.circle_outlined,
                  color: Color.fromARGB(0, 0, 0, 0),
                  size: dotSize,
                ),
        ),
      ],
    );
  }
}
