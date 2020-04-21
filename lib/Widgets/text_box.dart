import 'package:covid/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';

class TextBox extends StatefulWidget {
  TextBox({Key key,
    @required this.index,
    @required this.onBoxSelected,
    @required this.active
  }) : super(key: key);

  final int index;
  final bool active;
  final Function (int) onBoxSelected;

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => widget.onBoxSelected(widget.index),
      child: Container(
        margin: EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
        height: screenHeight(context, dividedBy: propTextBox),
        width: screenHeight(context, dividedBy: propTextBox),
        decoration: BoxDecoration(
          gradient: box_background,
          borderRadius: BorderRadius.circular(15),
          boxShadow: widget.active?inner_icon_shadow:outer_icon_shadow,
        ),
        child: Center(
          child: Text(
            iconBoxTexts[widget.index],
            style: TextStyle(color: getColorOfLine()),
          ),
        ),
      ),
    );
  }

  Color getColorOfLine(){
    Color lineColor = infected_text;
    switch(iconBoxTexts[widget.index]){
      case "D": lineColor = secondary_text;break;
      case "R": lineColor = recovered_text;break;
      case "A": lineColor = active_text;break;
      default: lineColor = infected_text;
    }
    return lineColor;
  }

}
