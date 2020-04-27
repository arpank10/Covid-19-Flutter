import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:flutter/material.dart';

class IconBox extends StatefulWidget {
  IconBox({Key key,
    @required this.index,
    @required this.onIconSelected,
    @required this.active
  }) : super(key: key);

  final int index;
  final bool active;
  final Function (int) onIconSelected;

  @override
  _IconBoxState createState() => _IconBoxState();
}

class _IconBoxState extends State<IconBox> {
  List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => widget.onIconSelected(widget.index),
      child: Container(
        margin: EdgeInsets.all(10.0),
        height: screenHeight(context, dividedBy: propBottomIcon),
        width: screenHeight(context, dividedBy: propBottomIcon),
        decoration: BoxDecoration(
          gradient: box_background,
          color: primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: widget.active?inner_shadow:outer_shadow,
        ),
        child: Center(
          child: Icon(
            bottom_nav_icons[widget.index],
            size: screenHeight(context, dividedBy: propBottomIcon*2.0),
            color: faded_orange,
          ),
        ),
      ),
    );
  }
}
