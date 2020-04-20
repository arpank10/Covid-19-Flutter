import 'package:covid/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';

class IconBox extends StatefulWidget {
  IconBox({Key key,
    @required this.icon,
    @required this.onIconSelected,
    @required this.active
  }) : super(key: key);

  final IconData icon;
  final bool active;
  final Function (IconData) onIconSelected;

  @override
  _IconBoxState createState() => _IconBoxState();
}

class _IconBoxState extends State<IconBox> {
  List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => widget.onIconSelected(widget.icon),
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
            widget.icon,
            size: screenHeight(context, dividedBy: propBottomIcon*2.0),
            color: faded_orange,
          ),
        ),
      ),
    );
  }
}
