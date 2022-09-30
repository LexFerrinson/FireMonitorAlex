import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

//fer callback per rebre al t_h_line_chart la pulsacio daquest widget i canviar el flag, pero el flag no es posa aqui

class ItemChartText extends StatefulWidget {
  const ItemChartText(
      {Key? key,
      required this.enabled,
      required this.text,
      required this.pressedCallback})
      : super(key: key);

  final bool enabled;
  final String text;
  final VoidCallback pressedCallback;

  @override
  State<ItemChartText> createState() => _ItemChartTextState();
}

class _ItemChartTextState extends State<ItemChartText> {
  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    Color? textColor;
    if (showAvg) {
      textColor = Colors.white.withOpacity(0.5);
    } else {
      if (widget.enabled) {
        textColor = Colors.white;
      } else {
        textColor = Colors.white.withOpacity(0.5);
      }
    }
    return SizedBox(
      width: 85,
      height: 30,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: widget.enabled
              ? const Color.fromARGB(255, 62, 80, 97)
              : const Color.fromARGB(255, 36, 45, 53),
        ),
        onPressed: () {
          setState(() {
            widget.pressedCallback();
          });
        },
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
