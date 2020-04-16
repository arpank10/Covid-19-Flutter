import 'package:covid/Database/country.dart';
import 'package:covid/Database/database_client.dart';
import 'package:covid/api.dart';
import 'package:covid/bottom_nav.dart';
import 'package:covid/box.dart';
import 'package:covid/custom_icons.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:covid/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covid/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid 19',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: primary,
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Raleway',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(title: 'Covid 19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String country = "india";
  Future<Country> futureCountry;
  final DatabaseClient db = DatabaseClient.instance;

  @override
  void initState() {
    super.initState();
    fetchAllStats();
    populateDatabase(context);
    futureCountry = db.fetchCountry(country);
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
      padding: const EdgeInsets.fromLTRB(0.0, top_padding, 0.0, 0.0),
        decoration: BoxDecoration(
          gradient: backgroud_gradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[
                SearchBar(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    country
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,40.0,0.0,15.0),
                  child: Center(
                    child: getCountryBoxes(),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: SvgPicture.asset(
                    'assets/wave.svg',
                    width: screenWidth(context),
                    placeholderBuilder: (context) => Icon(Icons.error)
                  ),
                ),
                Expanded(
                  flex: 10,
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
                BottomNav()
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
        print("Data");
        print(snapshot.data);
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
              increasedCount: snapshot.data.newConfirmed.toString(),
              totalCount: snapshot.data.totalConfirmed.toString(),
              icon: CustomIcon.active,
              alignment: TextAlign.right,
            )
            ],
          ),
        ]);
      } else {
        print("NO data");
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
}
