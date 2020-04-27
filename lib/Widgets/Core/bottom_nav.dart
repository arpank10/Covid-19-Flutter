import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_icons.dart';
import 'icon_box.dart';


class BottomNav extends StatefulWidget {
  BottomNav({
    Key key,
    @required this.onIconSelected
  }) : super(key: key);

  final Function (int) onIconSelected;

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int _selected = 0;

  void onIconSelected(int index){
    if(_selected!=index){
      setState(() {
        _selected = index;
      });
      widget.onIconSelected(_selected);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: screenHeight(context, dividedBy: propBottomIcon*2)
                + screenHeight(context, dividedBy: propPaddingLarge)),
              child: SvgPicture.asset(
                'assets/bottom_wave.svg',
                width: screenWidth(context),
                placeholderBuilder: (context) => Icon(Icons.error),
                color: faded_orange,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconBox(
                    index: 0,
                    onIconSelected: this.onIconSelected,
                    active: _selected==0,
                  ),
                  IconBox(
                    index: 1,
                    onIconSelected: this.onIconSelected,
                    active: _selected==1,
                  ),
                  IconBox(
                    index: 2,
                    onIconSelected: this.onIconSelected,
                    active: _selected==2,
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
