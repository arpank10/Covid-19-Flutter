import 'dart:convert';

import 'package:covid/Database/details.dart';
import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  int _currentBox = 0;
  Future<String> jsonData;

  @override
  void initState() {
    super.initState();
    jsonData = loadData();
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
            child: getCurrentBoxRow(),
          ),
          Container(
            margin: EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
            height: screenHeight(context, dividedBy: propContactsBox) - 2*screenHeight(context, dividedBy: propPaddingLarge),
            decoration: BoxDecoration(
              gradient: box_background,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: outer_shadow,
            ),
            child: getBox(),
          ),
        ],
      ),
    );
  }

  Future<String> loadData() async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/details.json");
    return data;
  }
  Widget getCurrentBoxRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          onPressed: () {
            if(_currentBox>0){
              setState(() {
                _currentBox--;
              });
              HapticFeedback.heavyImpact();
            }
          },
          icon: Icon(
            CustomIcon.left,
            size: screenHeight(context, dividedBy: 2*propCurrentBox),
            color: _currentBox == 0?secondary_text:orange,
          ),
        ),
        Text(
          currentBoxHeading[_currentBox],
          style: TextStyle(
            color: orange,
            fontSize: screenHeight(context, dividedBy: 2.5*propCurrentBox),
          ),
        ),
        IconButton(
          onPressed: (){
            if(_currentBox<currentBoxHeading.length-1){
              setState(() {
                _currentBox++;
              });
              HapticFeedback.heavyImpact();
            }
          },
          icon: Icon(
            CustomIcon.right,
            size: screenHeight(context, dividedBy: 2*propCurrentBox),
            color: _currentBox == currentBoxHeading.length-1?secondary_text:orange,
          ),
        ),
      ],
    );
  }

  Widget getBox(){
    switch(_currentBox){
      case 0: return getLinks();
      case 1: return getPrecautions();
      case 2: return getHelplines();
    }
    return getLinks();
  }

  Widget getLinks(){
    return FutureBuilder(
      future: jsonData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          String data = snapshot.data;

          var linksObject = jsonDecode(data)["Links"] as List;
          List<Link> links = linksObject.map((linkJson) => Link.fromJson(linkJson)).toList();

          return Scrollbar(
            child: ListView.builder(
              itemCount: links.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    links[index].text,
                    style: TextStyle(
                      color: orange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: (){
                    _launchURL(links[index].url);
                  },
                );
              }
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Widget getPrecautions(){

  }

  Widget getHelplines(){

  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
