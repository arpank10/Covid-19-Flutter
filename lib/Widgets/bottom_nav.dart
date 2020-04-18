import 'package:covid/Widgets/custom_icons.dart';
import 'package:covid/Widgets/icon_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter_svg/flutter_svg.dart';


class BottomNav extends StatefulWidget {
  BottomNav({
    Key key,
    @required this.onIconSelected
  }) : super(key: key);

  final Function (IconData) onIconSelected;

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  IconData _selected = CustomIcon.home;

  void onIconSelected(IconData icon){
    if(_selected!=icon){
      setState(() {
        _selected = icon;
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
                    icon: CustomIcon.home,
                    onIconSelected: this.onIconSelected,
                    active: _selected==CustomIcon.home,
                  ),
                  IconBox(
                    icon: CustomIcon.stats,
                    onIconSelected: this.onIconSelected,
                    active: _selected==CustomIcon.stats,
                  ),
                  IconBox(
                    icon: CustomIcon.contacts,
                    onIconSelected: this.onIconSelected,
                    active: _selected==CustomIcon.contacts,
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
