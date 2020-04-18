import 'package:covid/main.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';

class IconBox extends StatefulWidget {
  IconBox({Key key, this.icon, this.active}) : super(key: key);

  final IconData icon;
  final bool active;

  @override
  _IconBoxState createState() => _IconBoxState();
}

class _IconBoxState extends State<IconBox> {
  List<BoxShadow> shadow;


  getShadow(){
    if(widget.active)
      shadow = inner_shadow;
    else shadow = outer_shadow;
  }

  @override
  Widget build(BuildContext context) {
    getShadow();
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10.0),
      height: screenHeight(context, dividedBy: propBottomIcon),
      width: screenHeight(context, dividedBy: propBottomIcon),
      decoration: BoxDecoration(
        gradient: box_background,
        color: primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: shadow,
      ),
      child: Center(
        child: Icon(
          widget.icon,
          size: screenHeight(context, dividedBy: propBottomIcon*2.0),
          color: faded_orange,
        ),
      ),
    );
  }
}
