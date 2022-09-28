import 'package:flutter/material.dart';

typedef SelectedCallback = void Function(String);

class NodeCB extends StatefulWidget {
  const NodeCB(
      {Key? key,
      required this.startItem,
      required this.nodeItems,
      required this.selCallback})
      : super(key: key);

  final List<String> nodeItems;
  final SelectedCallback selCallback;
  final String? startItem;

  @override
  State<NodeCB> createState() => _NodeCBState();
}

class _NodeCBState extends State<NodeCB> {
  String? dropdownvalue;

  @override
  Widget build(BuildContext context) {
    if (widget.nodeItems.isNotEmpty) {
      if (!widget.nodeItems.contains(dropdownvalue)) {
        dropdownvalue = null;
      }
      dropdownvalue ??= widget.nodeItems.first;
    } else {
      dropdownvalue = null;
    }

    return DropdownButton(
      value: dropdownvalue,
      icon: const Icon(Icons.arrow_downward),
      items: widget.nodeItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dropdownvalue = value!;
          widget.selCallback(dropdownvalue!);
        });
      },
    );
  }
}
