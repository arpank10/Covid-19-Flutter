import 'package:covid/Database/country.dart';
import 'package:covid/Database/database_client.dart';
import 'package:covid/Widgets/bottom_nav.dart';
import 'package:covid/Widgets/box.dart';
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
    fetchAllStats().then((value) => this.loadStats());
    populateDatabase(context);
    loadStats();
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
                      print(value.country);
                      setState(() => country = value);
                      loadStats();
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
                          loadStats();
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
                      child: getCountryBoxes(),
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
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0,5.0),
                        child: Text(
                          quote,
                          style: TextStyle(fontStyle: FontStyle.italic, color: secondary_text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: Text(
                          stay,
                          style: TextStyle(color: primary_text, fontWeight: FontWeight.bold),
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

  Widget getCountryBoxes(){
    return FutureBuilder<Country>(
      future: futureCountry,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  Column(children: <Widget>[
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Infected",
                  increasedCount: snapshot.data.newConfirmed.toString(),
                  totalCount: snapshot.data.totalConfirmed.toString(),
                  icon: CustomIcon.corona,
                  alignment: TextAlign.left,
                ),
                DetailBox(
                  category: "Deceased",
                  increasedCount: snapshot.data.newDeaths.toString(),
                  totalCount: snapshot.data.totalDeaths.toString(),
                  icon: CustomIcon.dead,
                  alignment: TextAlign.right,
                )
              ],
            ),
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Recovered",
                  increasedCount: snapshot.data.newRecovered.toString(),
                  totalCount: snapshot.data.totalRecovered.toString(),
                  icon: CustomIcon.recovered,
                  alignment: TextAlign.left
                ),
                DetailBox(
                  category: "Active",
                  increasedCount: (snapshot.data.newConfirmed - snapshot.data.newRecovered - snapshot.data.newDeaths).toString(),
                  totalCount: (snapshot.data.totalConfirmed - snapshot.data.totalRecovered - snapshot.data.totalDeaths).toString(),
                  icon: CustomIcon.active,
                  alignment: TextAlign.right,
                )
              ],
            ),
          ]);
        } else {
          return  Column(children: <Widget>[
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Infected",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.corona,
                  alignment: TextAlign.left,
                ),
                DetailBox(
                  category: "Deceased",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.dead,
                  alignment: TextAlign.right,
                )
              ],
            ),
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Recovered",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.recovered,
                  alignment: TextAlign.left
                ),
                DetailBox(
                  category: "Active",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.active,
                  alignment: TextAlign.right,
                )
              ],
            ),
          ]);
        }
        return CircularProgressIndicator();
      });
  }


  void populateDatabase(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = await prefs.getBool('firstTime') ?? true;
    if(isFirstTime){
      prefs.setBool('firstTime', false);
      await db.populateCountries(context);
    }
  }

  void loadStats(){
    if(country == null)
      setState(() {
        futureCountry = db.fetchCountry("global");
      });
    else
      setState(() {
        futureCountry = db.fetchCountry(country.slug);
      });
  }
}
