import 'package:covid/Database/country.dart';
import 'package:covid/Database/database_client.dart';
import 'package:covid/Widgets/bottom_nav.dart';
import 'package:covid/Widgets/box.dart';
import 'package:covid/Widgets/country_stat.dart';
import 'package:covid/Widgets/custom_icons.dart';
import 'package:covid/Widgets/graph.dart';
import 'package:covid/Widgets/search.dart';
import 'package:covid/api.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covid/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  IconData _currentSelected = CustomIcon.home;
  Country country;
  Future<Country> futureCountry;
  final DatabaseClient db = DatabaseClient.instance;

  @override
  void initState() {
    super.initState();
    fetchAllStats();
    populateDatabase(context);

  }

  void populateDatabase(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = await prefs.getBool('firstTime') ?? true;
    if(isFirstTime){
      prefs.setBool('firstTime', false);
      await db.populateCountries(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroud_gradient,
//          color: background
        ),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: screenHeight(context, dividedBy: propPaddingLarge)),
                  child: SearchBar(
                    onCountrySelected: (Country value){
//                      print(value.country);
                      setState(() => country = value);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenHeight(context, dividedBy: propPaddingLarge)),
                  height: screenHeight(context, dividedBy: propCurrentCountry),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        country == null? "Global":country.country
                      ),
                      IconButton(
                        icon: Center(
                          child: Icon(
                            CustomIcon.global,
                            size: screenHeight(context, dividedBy: propGlobalIcon),
                            color: country==null?faded_orange:(country.slug=='global'?faded_orange:secondary_text)
                          ),
                        ),
                        onPressed: (){
                          setState(() {
                            country = null;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: _currentSelected == CustomIcon.stats,
                  child: Graph(country: country),
                ),
                Visibility(
                  visible: _currentSelected == CustomIcon.home,
                  child: Container(
                    child: Center(
                      child: StatBox(country: country),
                    ),
                  ),
                ),
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
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight(context, dividedBy: propPaddingLarge)),
                  height: screenHeight(context, dividedBy: propBottomNavBar),
                  child: BottomNav(
                    onIconSelected: (IconData data){
                      if(_currentSelected!=data){
                        setState(() {
                          _currentSelected = data;
                        });
                        print("Selection changed");
                      }
                    },
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }


}
