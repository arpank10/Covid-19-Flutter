import 'package:covid/Database/country.dart';
import 'package:covid/main.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';

import 'Database/database_client.dart';

class DetailBox extends StatefulWidget {
  DetailBox({Key key, this.category, this.increasedCount, this.totalCount, this.icon, this.alignment, String country}) : super(key: key);

  final String category;
  final String increasedCount;
  final String totalCount;
  final IconData icon;
  final TextAlign alignment;

  @override
  _DetailBoxState createState() => _DetailBoxState();
}

class _DetailBoxState extends State<DetailBox> {
  Color textColor = primary_text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch(widget.category){
      case "Infected": textColor = primary_text;break;
      case "Deceased": textColor = deceased_text;break;
      case "Recovered": textColor = recovered_text;break;
      case "Active": textColor = active_text;break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10.0),
      height: screenHeight(context, dividedBy: 5),
      width: screenWidth(context, dividedBy: 2) - 20,
      decoration: BoxDecoration(
        gradient: box_background,
        color: primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: outer_shadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                widget.icon,
                color: faded_orange,
              ),
              Text(
                "+" + widget.increasedCount,
                style: TextStyle(color: faded_orange),
              )
            ],
          ),
          Center(
            child: Text(
              widget.totalCount,
              style: TextStyle(fontSize: 25, color: primary_text, fontWeight:FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.category,
              textAlign: widget.alignment,
            ),
          )
        ],
      ),
    );
  }
}
