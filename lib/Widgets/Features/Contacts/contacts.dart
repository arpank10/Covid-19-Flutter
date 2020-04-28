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
    return FutureBuilder(
      future: jsonData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          String data = snapshot.data;

          var precautionObjects = jsonDecode(data)["Precautions"] as List;
          List<Precaution> precautions = precautionObjects.map((precautionJson) => Precaution.fromJson(precautionJson)).toList();

          return Scrollbar(
            child: ListView.builder(
              itemCount: precautions.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: screenHeight(context, dividedBy: propPrecautionTile) - screenHeight(context, dividedBy: propPaddingSmall),
                  padding: EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: <Widget>[
                      index%2==0?getRowImage(precautions[index].image):getRowText(precautions[index].text, precautions[index].description),
                      index%2==1?getRowImage(precautions[index].image):getRowText(precautions[index].text, precautions[index].description),
                    ],
                  ),
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

  Widget getRowImage(String image){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight(context, dividedBy: propPaddingLarge)),
      child: Image(
        height: screenHeight(context, dividedBy: propPrecautionImage),
        width: screenHeight(context, dividedBy: propPrecautionImage),
        image: AssetImage(image),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget getRowText(String title, String description){
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: faded_orange,
              fontSize: 15.0
            ),
            textScaleFactor: 1.0,
          ),
          Text(
            description,
            style: TextStyle(fontSize:13.0,color: secondary_text.withOpacity(0.50)),
            textScaleFactor: 1.0,
          ),
        ],
      ),
    );
  }

  Widget getHelplines(){
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
