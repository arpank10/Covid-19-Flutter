import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var margin = screenHeight(context, dividedBy: propPaddingLarge);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 2*margin, 0.0, margin),
            height: screenHeight(context, dividedBy: propTitleText),
            child: Center(
              child: Text(app_title),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight(context, dividedBy: propPaddingSmall)),
            height: screenHeight(context, dividedBy: propCurrentBox),
            color: Colors.cyan,
          ),
          Container(
            padding: EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
            height: screenHeight(context, dividedBy: propContactsBox),
            color: Colors.green,
          ),
        ],
      ),
    );
  }


}
