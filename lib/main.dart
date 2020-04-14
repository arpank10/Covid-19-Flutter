import 'package:covid/box.dart';
import 'package:covid/custom_icons.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:covid/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//- Background Surface : linear-gradient(180deg, #22242D 0%, #131517 68.75%);
//- Box- Background: linear-gradient(180deg, #1B1E27 0%, #121212 100%);
//- Primary text : #E0E0E0
//- Secondary text : rgba(224, 224, 224, 0.5);
//- Accent: #F37C4A;
//- Faded Orange: rgba(243, 124, 74, 0.75);

const primary = const Color(0xff121212);
const box_gradient_top = const Color(0xff1B1E27);
const box_gradient_bottom = const Color(0xff121212);
const orange = const Color(0xffF37C4A);
const primary_text = const Color(0xffE0E0E0);
const secondary_text =  Color.fromRGBO(224, 224, 224, 0.5);
const faded_orange =  Color.fromRGBO(243, 124, 74, 0.75);
const quote = "You can't recognize good times, if you don't have bad ones.";



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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: primary, //No more green
        elevation: 0.0
      ),
      //Body contains
      //Column
      //Search widget
      //4 cards
      //Wave
      //Bottom Navigation Bar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SearchBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0,40.0,0.0,15.0),
              child: Center(
                  child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    DetailBox(
                        category: "Infected",
                        url: "infected",
                        icon: CustomIcon.corona,
                        alignment: TextAlign.left,
                    ),
                    DetailBox(
                        category: "Deceased",
                        url: "infected",
                        icon: CustomIcon.dead,
                        alignment: TextAlign.right,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    DetailBox(
                        category: "Recovered",
                        url: "infected",
                        icon: CustomIcon.recovered,
                        alignment: TextAlign.left
                    ),
                    DetailBox(
                        category: "Active",
                        url: "infected",
                        icon: CustomIcon.active,
                        alignment: TextAlign.right,
                    )
                  ],
                ),
              ])),
            ),
            SvgPicture.asset(
              'assets/wave.svg',
              width: screenWidth(context),
              placeholderBuilder: (context) => Icon(Icons.error)
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Text(
                quote,
              ),
            )
          ],
        ),
      ),
    );
  }
}
