import 'dart:math';

import 'package:covid/Database/cases.dart';
import 'package:covid/Database/country.dart';
import 'package:covid/Helpers/api.dart';
import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:covid/Widgets/Core/search.dart';
import 'package:covid/Widgets/Features/Graph/graph_box.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Graph extends StatefulWidget {
  Graph({Key key,
    @required this.country,
    @required this.onCountryChanged,
  }) : super(key: key);

  final Country country;
  final Function(Country) onCountryChanged;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  Country country;

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
                child: GraphBox(country: country),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
