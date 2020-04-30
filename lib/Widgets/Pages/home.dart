import 'dart:io';

import 'package:covid/Database/country.dart';
import 'package:covid/Database/database_client.dart';
import 'package:covid/Database/details.dart';
import 'package:covid/Helpers/api.dart';
import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:covid/Widgets/Core/bottom_nav.dart';
import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:covid/Widgets/Core/search.dart';
import 'package:covid/Widgets/Features/Contacts/contacts.dart';
import 'package:covid/Widgets/Features/Graph/graph.dart';
import 'package:covid/Widgets/Features/Stats/country_stat.dart';
import 'package:covid/Widgets/Features/Stats/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentSelected = 0;
  Country _country;
  API api = new API();

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  void checkForUpdate() async{
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    int currentVersion = int.parse(info.buildNumber);

//    int currentVersion = 0;

    //Get new version
    Version versionDetails = await api.fetchVersionInfo();
    int latestVersion = versionDetails.versionCode;

    if(currentVersion<latestVersion)
      _showVersionDialog(context, versionDetails.url);
  }

  _showVersionDialog(context, url) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

      return Platform.isIOS
        ? new CupertinoAlertDialog(
          title: Text(
            update_title,
            style: TextStyle(color: orange, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
          ),
          content: Text(
            update_message,
            style: TextStyle(color: secondary_text, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, fontFamily: 'Roboto'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(update_btnLabel),
              onPressed: () => _launchURL(url),
            ),
            FlatButton(
              child: Text(update_btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
      )
        : new AlertDialog(
          backgroundColor:  background,
          title: Text(
            update_title,
            style: TextStyle(color: orange, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
          ),
          content: Text(
            update_message,
            style: TextStyle(color: secondary_text, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, fontFamily: 'Roboto'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(update_btnLabel),
              onPressed: () => _launchURL(url),
            ),
            FlatButton(
              child: Text(update_btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
      );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroud_gradient,
        ),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                getFeature(),
                Container(
                  height: screenHeight(context, dividedBy: propBottomElement),
                  child: SvgPicture.asset(
                    'assets/wave.svg',
                    width: screenWidth(context),
                    placeholderBuilder: (context) => Icon(Icons.error)
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight(context, dividedBy: propPaddingSmall)),
                  height: screenHeight(context, dividedBy: propBottomElement),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenHeight(context, dividedBy: propPaddingLarge)),
                        child: Text(
                          quote,
                          style: TextStyle(fontStyle: FontStyle.italic, color: secondary_text),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenHeight(context, dividedBy: propPaddingLarge),
                        vertical: screenHeight(context, dividedBy: propPaddingSmall)),
                        child: Text(
                          stay,
                          style: TextStyle(color: primary_text, fontWeight: FontWeight.bold),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                getBottomNavBar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCountryChanged(Country newCountry){
    if(_country != newCountry){
      setState(() {
        _country = newCountry;
      });
    }
  }

  Widget getBottomNavBar(){
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight(context, dividedBy: propPaddingLarge)),
      height: screenHeight(context, dividedBy: propBottomNavBar),
      child: BottomNav(
        onIconSelected: (int index){
          if(_currentSelected!=index){
            setState(() {
              _currentSelected = index;
            });
            print("Selection changed");
          }
        },
      ));
  }

  Widget getFeature(){
    switch(_currentSelected){
      case 0: return Stats(country: _country,onCountryChanged:this.onCountryChanged);
      case 1: return Graph(country: _country,onCountryChanged:this.onCountryChanged);
      case 2: return Contacts();
    }
    return Contacts();
  }

}
