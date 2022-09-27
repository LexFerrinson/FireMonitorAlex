import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

//fer callback per rebre al t_h_line_chart la pulsacio daquest widget i canviar el flag, pero el flag no es posa aqui

class ItemChartText extends StatefulWidget {
  const ItemChartText(
      {Key? key, required this.text, required this.pressedCallback})
      : super(key: key);

  final String text;
  final VoidCallback pressedCallback;

  @override
  State<ItemChartText> createState() => _ItemChartTextState();
}

class _ItemChartTextState extends State<ItemChartText> {
  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 34,
      child: TextButton(
        onPressed: () {
          setState(() {
            widget.pressedCallback();
          });
        },
        child: Text(
          widget.text,
          style: TextStyle(
              fontSize: 12,
              color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
        ),
      ),
    );
  }
}
