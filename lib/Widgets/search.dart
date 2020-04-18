import 'dart:async';

import 'package:covid/Database/country.dart';
import 'package:covid/Database/database_client.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';


class SearchBar extends StatefulWidget {
  SearchBar({Key key, @required this.onCountrySelected}) : super(key: key);

  final Function(Country) onCountrySelected;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = new TextEditingController();
  final DatabaseClient db = DatabaseClient.instance;
  final FocusNode _focusNode = FocusNode();


  OverlayEntry _overlayEntry;
  Future<List<Country>> countryList;
  List<Country> allCountryList;
  List<Country> tempFilterList;
  String _searchText = "";
  int _previousLength = 0;
  Timer _debounce;

  _onSearchChanged(){
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with _searchQuery.text
      if(_controller.text.isEmpty){
        setState(() {
          _searchText = "";
          countryList.then((value) => allCountryList = value);
          countryList.then((value) => tempFilterList = value);
        });
        if(this._overlayEntry!=null){
          print("removing entry");
          this._overlayEntry.remove();
          this._overlayEntry = null;
        }
      } else {
        setState(() {
          _searchText = _controller.text;
          if(_overlayEntry==null){
            this._overlayEntry = this._createOverlayEntry();
            Overlay.of(context).insert(this._overlayEntry);
          } else {
            this._overlayEntry.markNeedsBuild();
          }
        });
        print(_searchText);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    countryList = db.fetchAllCountries();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var margin = screenHeight(context, dividedBy: propPaddingLarge);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: screenHeight(context, dividedBy: propPaddingLarge)),
          height: screenHeight(context, dividedBy: propTitleText),
          child: Center(
            child: Text("Covid 19"),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(margin, 0.0, margin, margin),
          decoration: BoxDecoration(
            color: search_bar_colour,
            boxShadow: inner_shadow,
            borderRadius: BorderRadius.circular(30.0)
          ),
          child: Center(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              decoration: new InputDecoration(
                hintText: "Search for Country",
                prefixIcon: new Icon(Icons.search),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List<Country> tempList = new List();
      if(_searchText.length < _previousLength){
        print("Less than before");
        tempFilterList = allCountryList;
      }
      for (int i = 0; i < tempFilterList.length; i++) {
        if(tempFilterList[i].country.toLowerCase().contains(_searchText.toLowerCase())){
          tempList.add(tempFilterList[i]);
          print(tempFilterList[i].country);
        }
      }
      print(_searchText);
      _previousLength = _searchText.length;
      tempList.sort((a, b) => a.country.compareTo(b.country));
      tempFilterList = tempList;
    }
    return ListView.builder(
      itemCount: countryList == null ? 0 : tempFilterList.length,
      itemBuilder: (BuildContext context, int index) {
        return Theme(
          data: ThemeData(
            highlightColor: Colors.cyan,
            brightness: Brightness.dark,
            primaryColor: primary,
            accentColor: faded_orange,
          ),
          child: new ListTile(
            title: Text(
              tempFilterList[index].country,
              style: TextStyle(color: faded_orange),
            ),
            onTap: (){
              _controller.clear();
              this.sendCountryToParent(tempFilterList[index]);
            },
          ),
        );
      },
    );
  }

  OverlayEntry _createOverlayEntry() {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    print("Creating entry");
    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height - 5.0,
        width: size.width,
        child: Material(
          elevation: 4.0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: box_background,
              boxShadow: inner_shadow,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 35.0, vertical: 0.0),

            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 35.0,
                maxHeight: screenHeight(context, dividedBy: 4),
              ),
              child: _buildList(),
            ),
          ),
        ),
      )
    );
  }

  void sendCountryToParent(Country country){
    widget.onCountrySelected(country);
    this._overlayEntry.remove();
    this._overlayEntry = null;
  }
}
