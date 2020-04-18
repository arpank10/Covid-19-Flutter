import 'file:///E:/Android/Self/covid/lib/Widgets/custom_icons.dart';
import 'file:///E:/Android/Self/covid/lib/Widgets/icon_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter_svg/flutter_svg.dart';



class BottomNav extends StatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconBox(icon: CustomIcon.home, active: true),
                  IconBox(icon: CustomIcon.stats, active: false),
                  IconBox(icon: CustomIcon.contacts, active: false),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight(context, dividedBy: propBottomIcon*2)
              + screenHeight(context, dividedBy: propPaddingSmall)),
              child: SvgPicture.asset(
                'assets/bottom_wave.svg',
                width: screenWidth(context),
                placeholderBuilder: (context) => Icon(Icons.error),
                color: faded_orange,
              ),
            ),
          ],
        ),
    );
  }
}
