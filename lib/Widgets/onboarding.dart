import 'package:covid/constants.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';


class OnboardScreens extends StatefulWidget {
  OnboardScreens({Key key}) : super(key: key);

  @override
  _OnboardScreensState createState() => _OnboardScreensState();
}

class _OnboardScreensState extends State<OnboardScreens> {
  int _selectedScreen = 0;

  void pageChanged(int page){
    setState(() {
      _selectedScreen = page;
    });
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
                  style: TextStyle(fontFamily: 'Raleway', color: secondary_text, fontSize: 24, fontWeight: FontWeight.w500),
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
                    getRichText(onboard_headings[index]),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight(context, dividedBy: propPaddingLarge)),
                      child: Text(
                        onboard_description[index],
                        textAlign: TextAlign.start,
                        style: TextStyle(color: secondary_text, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
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

  Widget getRichText(String quote){
    List<String> words = quote.split(" ");
    List<TextSpan> spans = new List();

    words.forEach((word) {
      String first = word[0];
      String other = word.substring(1) + " ";
      spans.add(new TextSpan(
        text: first,
        style: TextStyle(color: orange)
      ));
      spans.add(new TextSpan(
        text: other,
        style: TextStyle(color: primary_text)
      ));
    });

    return new RichText(
      text: TextSpan(
        style: TextStyle(fontFamily: 'Raleway', fontSize: 40, letterSpacing: 2, fontWeight: FontWeight.w800),
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