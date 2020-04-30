import 'package:covid/Database/country.dart';
import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:covid/Widgets/Core/search.dart';
import 'package:flutter/services.dart';
import 'country_stat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  Stats({Key key, this.country, this.onCountryChanged}) : super(key: key);

  final Country country;
  final Function(Country) onCountryChanged;

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  Country country;
  final GlobalKey<StatBoxState> _statBoxState = GlobalKey<StatBoxState>();


  @override
  void initState() {
    super.initState();
    country = widget.country;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: screenHeight(context, dividedBy: propPaddingLarge)),
              child: SearchBar(
                onCountrySelected: (Country value){
                  setState(() => country = value);
                  widget.onCountryChanged(value);
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
                        Icons.refresh,
                        size: screenHeight(context, dividedBy: propGlobalIcon),
                        color: faded_orange
                      ),
                    ),
                    onPressed: (){
                      HapticFeedback.heavyImpact();
                      _statBoxState.currentState.loadStats();
                    },
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
            Container(
              child: Center(
                child: StatBox(key:_statBoxState, country: country),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
