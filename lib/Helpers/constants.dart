import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


const app_title = "Covid 19";


//-----------------------------------Colors----------------------------------//
const primary = const Color(0xff121212);
const background =  Color.fromRGBO(19,21,23,1.0);
const search_bar_colour = const Color.fromRGBO(34,36,45,1.0);
const box_gradient_top = const Color(0xff1B1E27);
const box_gradient_bottom = const Color(0xff121212);
const orange = const Color(0xffF37C4A);
const primary_text = const Color(0xffE0E0E0);
const secondary_text =  Color.fromRGBO(224, 224, 224, 0.5);
const infected_text = Color.fromRGBO(214, 53, 53, 0.5);
const recovered_text = Color.fromRGBO(39, 174, 96, 0.5);
const active_text = Color.fromRGBO(45, 156, 219, 0.5);
const faded_orange =  Color.fromRGBO(243, 124, 74, 0.75);
const topShadow = const Color.fromRGBO(255, 250, 250, 0.2);
const bottomShadow = const Color.fromRGBO(0, 0, 0, 0.75);

const onboardA =  Color.fromRGBO(19,21,23,1.0);
const onboardB =  Color.fromRGBO(255,255,255,1.0);
const onboardC =  onboardA;

const alternate_text = Color.fromRGBO(19,21,23,0.7);

//const textHeadingColor = [orange, onboardA, orange];
const textHeadingOtherColor = [primary_text, alternate_text, primary_text, primary_text];

//----------------------------------Gradients---------------------------------//
const backgroud_gradient = const LinearGradient(
//  begin: const FractionalOffset(0.0, 0.0),
//  end: const FractionalOffset(0.0, 0.6875),
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color.fromRGBO(34,36,45,1.0), Color.fromRGBO(19,21,23,0.5)],
//  colors: [orange, Color.fromRGBO(19,21,23,1.0)],
  stops: [0.0, 1.0],
  tileMode: TileMode.clamp
);
const box_background = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color.fromRGBO(27,30,39,1.0), Color.fromRGBO(18, 18, 18 ,0.9)],
  stops: [0.0, 1.0],
  tileMode: TileMode.clamp
);


//----------------------------------dimensions---------------------------------//
const outerBlurLevel = 4.0;
const innerBlurLevel = 1.0;
const blurOffsetOuter = 4.0;
const blurOffsetInner = 2.0;
const top_padding = 20.0;
const blurSpreadInner = 1.0;

const outerIconBlur = 1.0;
const innerIconBlur = 1.0;
const outerBlurIconOffset = 1.0;
const innerBlurIconOffset = 1.0;
const innerBlurIconSpread = 1.0;


//----------------------------------proportions---------------------------------//
//top
const propTitleText = 40.0;
const propSearchElement = 18.0;
const propCurrentCountry = 20.0;
const propGlobalIcon = 30.0;


//middle
const propStatBox = 2.5;
const propStatIndividualBox = 5.0;

//bottom
const propBottomElement = 10.0;
const propBottomNavBar = 10.0;
const propBottomIcon = 20.0;

//padding
const propPaddingLarge = 80.0;
const propPaddingSmall = 160.0;

//text box
const propTextBox = 25.0;
const propTimingBox = 30.0;
const propTopPadding = 20.0;

//Contacts Page
const propCurrentBox = 18.0;
const propContactsBox = 2.0;
const propPrecautionTile = 8.0;
const propPrecautionImage = 10.0;

//Flex values
const flexTopQuote = 5;
const flexImage = 7;
const flexHeading = 6;
const flexIndicators = 3;


//----------------------------------Shadows---------------------------------//
const outer_shadow = const [
  BoxShadow(
    blurRadius: outerBlurLevel,
    offset: Offset(
      -blurOffsetOuter,
      -blurOffsetOuter,
    ),
    color: topShadow,
  ),
  BoxShadow(
    blurRadius: outerBlurLevel,
    offset: Offset(
      blurOffsetOuter,
      blurOffsetOuter,
    ),
    color: bottomShadow
  )
];

const inner_shadow = const [
  BoxShadow(
    blurRadius: innerBlurLevel,
    offset: Offset(
      -blurOffsetInner,
      -blurOffsetInner
    ),
    spreadRadius: blurSpreadInner,
    color: bottomShadow,
  ),
  BoxShadow(
    blurRadius: innerBlurLevel,
    offset: Offset(
      blurOffsetInner,
      blurOffsetInner
    ),
    spreadRadius: blurSpreadInner,
    color: topShadow
  )
];
const outer_icon_shadow = const [
  BoxShadow(
    blurRadius: outerIconBlur,
    offset: Offset(
      -outerBlurIconOffset,
      -outerBlurIconOffset,
    ),
    color: topShadow,
  ),
  BoxShadow(
    blurRadius: outerIconBlur,
    offset: Offset(
      outerBlurIconOffset,
      outerBlurIconOffset,
    ),
    color: bottomShadow
  )
];

const inner_icon_shadow = const [
  BoxShadow(
    blurRadius: innerIconBlur,
    offset: Offset(
      -innerBlurIconOffset,
      -innerBlurIconOffset
    ),
    spreadRadius: innerBlurIconSpread,
    color: bottomShadow,
  ),
  BoxShadow(
    blurRadius: innerIconBlur,
    offset: Offset(
      innerBlurIconOffset,
      innerBlurIconOffset
    ),
    spreadRadius: innerBlurIconSpread,
    color: topShadow
  )
];

//----------------------------------Arrays---------------------------------//
const timingBoxTexts = ["Beginning", "1 Month", "2 Weeks"];
const iconBoxTexts = ["I", "D", "R", "A"];
const selectedChartHeading = ["Cumulative", "Daily"];
const currentBoxHeading = ["Important Links", "Precautions"];
const linkTypes = [CustomIcon.launch, CustomIcon.contacts];

//----------------------------------Arrays---------------------------------//
const onboard_qoutes = ["Ignorance isn't bliss always", "Stay ahead of the curve, always", "Save the world by staying at home"];
const onboard_headings = ["Know the figures", "Flatten the curve", "It's time to start"];
const onboard_description = [
  "Real time updates from data curated by John Hopkins University. View the numbers of the Covid-19 strain worldwide or in your own country.",
  "Visualize the curves that everyone is trying to flatten. Data from 22nd January are available to view as line and bar charts.",
  ""
];

const bottom_qoute = [
  '"You can\'t recognize good times, if you don\'t have bad ones."',
  '"An ounce of prevention is worth a pound of cure"',
  '"When "I" is replaced by "We", even illness becomes wellness"'];

const bottom_heading = [
  'Stay Home, Stay Safe',
  'Viruses don\'t discriminate',
  'Let\'s give it our best'];
//--------------------------------------Strings-------------------------------------//
const update_title = "New Update Available";
const update_message = "There is a newer version of app available, please update it now.";
const update_btnLabel = "Update Now";
const update_btnLabelCancel = "Later";


//----------------------------------Api---------------------------------//
const BASE_URL = "https://api.covid19api.com/";
//const BASE2_URL = "https://corona.lmao.ninja/";
const BASE2_URL = "https://disease.sh/";
const UPDATE_CHECK_URL = "https://gist.githubusercontent.com/arpank10/6670a1f1e29382e73f2276715930e4fc/raw/de6084312bf1710e4fe3d4f4692b410fe7fb26be/covid_version.json";

//ALL COUNTRY DATA
const summary = "summary";
const globalData = "v2/historical/all?lastdays=";
const countryWise = "v2/historical/";

const bottom_nav_icons = [CustomIcon.home, CustomIcon.stats, CustomIcon.contacts];