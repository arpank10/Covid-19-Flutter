import 'package:covid/Database/database_client.dart';
import 'package:covid/Helpers/api.dart';
import 'package:covid/constants.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnboardScreens extends StatefulWidget {
  OnboardScreens({Key key}) : super(key: key);

  @override
  _OnboardScreensState createState() => _OnboardScreensState();
}

class _OnboardScreensState extends State<OnboardScreens> {
  int _selectedScreen = 0;
  final DatabaseClient db = DatabaseClient.instance;
  final API api = new API();

  void populateDatabase(BuildContext context) async {
    await db.populateCountries(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateDatabase(context);
    api.fetchAllStats();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      pages: getPages(context),
//      enableSlideIcon: true,
      enableLoop: false,
      fullTransitionValue: 600.0,
      onPageChangeCallback: this.pageChanged
    );
  }

  void goToHomeScreen() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/app');
  }


  void pageChanged(int page){
    setState(() {
      _selectedScreen = page;
    });
  }

  List<Container> getPages(BuildContext context){
    List<Container> pages = new List();
    pages.add(getPage(onboardA, 'assets/world-2.png', 0, context));
    pages.add(getPage(onboardB, 'assets/chart.png', 1, context));
    pages.add(getPage(onboardC, 'assets/world-1.png', 2, context));
    return pages;
  }

  Container getPage(Color color, String image,  int index, BuildContext context){
    return  Container(
      width: screenWidth(context),
      height: screenHeight(context),
      child: Material(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: flexTopQuote,
              child: Center(
                child: Text(
                  '"' + onboard_qoutes[index] + '"',
                  style: TextStyle(fontFamily: 'Raleway', color: textHeadingOtherColor[index], fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
              flex: flexImage,
              child: Container(
                margin: EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
                width: screenWidth(context) - screenWidth(context, dividedBy: 10.0 ),
                height: screenHeight(context, dividedBy: 3.5),
                child: Image(image: AssetImage(image)),
              ),
            ),
            Expanded(
              flex: flexHeading,
              child: Padding(
                padding: EdgeInsets.all(screenWidth(context, dividedBy: 10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getRichText(onboard_headings[index], index),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight(context, dividedBy: propPaddingLarge)),
                      child: getDescription(index),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: flexIndicators,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getPageIndicators(0),
                  getPageIndicators(1),
                  getPageIndicators(2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getDescription(int index){
    if(index != 2){
      return Text(
        onboard_description[index],
        textAlign: TextAlign.start,
        style: TextStyle(color: textHeadingOtherColor[index], fontSize: 15, fontWeight: FontWeight.bold),
      );
    }
    return Center(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          goToHomeScreen();
        },
        child: Container(
          width: screenWidth(context,dividedBy: 2.5),
          padding : EdgeInsets.all(screenHeight(context, dividedBy: propPaddingSmall)),
          margin : EdgeInsets.symmetric(vertical: screenHeight(context, dividedBy: propPaddingLarge)),
          decoration: BoxDecoration(
            color: background,
            boxShadow: outer_shadow,
            borderRadius: BorderRadius.circular(4.0)
          ),
          child: Center(
            child: getRichText("Let's Go", 3)
          ),
        ),
      ),
    );
  }

  Widget getRichText(String quote, int index){
    List<String> words = quote.split(" ");
    List<TextSpan> spans = new List();

    words.forEach((word) {
      String first = word[0];
      String other = word.substring(1) + " ";
      spans.add(new TextSpan(
        text: first,
        style: TextStyle(
          color: orange
        )
      ));
      spans.add(new TextSpan(
        text: other,
        style: TextStyle(
          color: textHeadingOtherColor[index]
        )
      ));
    });

    return new RichText(
      text: TextSpan(
        style: TextStyle(fontFamily: 'Raleway', fontSize: index==3?20:40, letterSpacing: 2, fontWeight: FontWeight.w800),
        children: spans
      )
    );
  }

  Widget getPageIndicators(int index){
    double size = screenHeight(context, dividedBy: propPaddingSmall);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenHeight(context, dividedBy: propPaddingLarge)),
      width: _selectedScreen == index?size+2.0:size,
      height: _selectedScreen == index?size+2.0:size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _selectedScreen == index?orange : secondary_text ,
      ),
    );
  }
}