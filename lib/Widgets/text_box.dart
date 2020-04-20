import 'package:covid/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';

class TextBox extends StatefulWidget {
  TextBox({Key key,
    @required this.text,
    @required this.onBoxSelected,
    @required this.active
  }) : super(key: key);

  final String text;
  final bool active;
  final Function (String) onBoxSelected;

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => widget.onBoxSelected(widget.text),
      child: Container(
        margin: EdgeInsets.all(10.0),
        height: screenHeight(context, dividedBy: propTextBox),
        width: screenHeight(context, dividedBy: propTextBox),
        decoration: BoxDecoration(
          gradient: box_background,
          color: primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: widget.active?inner_icon_shadow:outer_icon_shadow,
        ),
        child: Center(
          child: Text(widget.text),
        ),
      ),
    );
  }
}
