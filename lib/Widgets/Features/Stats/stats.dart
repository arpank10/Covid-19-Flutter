import 'package:covid/Database/country.dart';
import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:covid/Widgets/Core/search.dart';
import 'country_stat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  Stats({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  Country country;
  Future<Country> futureCountry;

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
                  visible: _currentSelected == CustomIcon.home,
                  child: Container(
                    child: Center(
                      child: StatBox(country: country),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
