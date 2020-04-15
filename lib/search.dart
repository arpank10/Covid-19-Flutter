import 'package:flutter/material.dart';
import 'package:covid/constants.dart';


class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Center(
          child: Text("Covid 19"),
        ),
        Center(
         child:
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: search_bar_colour,
              boxShadow: inner_shadow,
              borderRadius: BorderRadius.circular(30.0)
            ),
            child: TextField(
              decoration: new InputDecoration(
                hintText: "Search for Country",
                prefixIcon: new Icon(Icons.search),
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
