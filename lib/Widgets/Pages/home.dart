import 'package:covid/Database/country.dart';
import 'package:covid/Database/database_client.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentSelected = 0;
  Country _country;

  @override
  void initState() {
    super.initState();
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
