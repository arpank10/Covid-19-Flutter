import 'package:covid/main.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';

class DetailBox extends StatefulWidget {
  DetailBox({Key key, this.category, this.url, this.icon, this.alignment}) : super(key: key);

  final String category;
  final String url;
  final IconData icon;
  final TextAlign alignment;

  @override
  _DetailBoxState createState() => _DetailBoxState();
}

class _DetailBoxState extends State<DetailBox> {
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
                "+90000",
                style: TextStyle(color: faded_orange),
              )
            ],
          ),
          Center(
            child: Text(
              "+1,500,000",
              style: TextStyle(fontSize: 25, color: primary_text),
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
