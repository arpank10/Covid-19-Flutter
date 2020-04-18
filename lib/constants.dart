import 'package:covid/screensize_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//-----------------------------------Colors----------------------------------//
const primary = const Color(0xff121212);
const search_bar_colour = const Color.fromRGBO(34,36,45,1.0);
const box_gradient_top = const Color(0xff1B1E27);
const box_gradient_bottom = const Color(0xff121212);
const orange = const Color(0xffF37C4A);
const primary_text = const Color(0xffE0E0E0);
const secondary_text =  Color.fromRGBO(224, 224, 224, 0.5);
const deceased_text = Color.fromRGBO(214, 53, 53, 0.5);
const recovered_text = Color.fromRGBO(39, 174, 96, 0.5);
const active_text = Color.fromRGBO(45, 156, 219, 0.5);
const faded_orange =  Color.fromRGBO(243, 124, 74, 0.75);
const topShadow = const Color.fromRGBO(255, 250, 250, 0.2);
const bottomShadow = const Color.fromRGBO(0, 0, 0, 0.75);

//----------------------------------Gradients---------------------------------//
const backgroud_gradient = const LinearGradient(
  begin: const FractionalOffset(0.0, 0.0),
  end: const FractionalOffset(0.0, 0.6875),
  colors: [Color.fromRGBO(34,36,45,1.0), Color.fromRGBO(19,21,23,1.0)],
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

//----------------------------------Strings---------------------------------//
const stay = "Stay Home, Stay Safe";
const quote = "'You can't recognize good times, if you don't have bad ones.'";

//----------------------------------dimensions---------------------------------//
const outerBlurLevel = 4.0;
const innerBlurLevel = 1.0;
const blurOffsetOuter = 4.0;
const blurOffsetInner = 2.0;
const top_padding = 20.0;
const blurSpreadInner = 1.0;


//----------------------------------proportions---------------------------------//
//top
const propTitleText = 40.0;
const propSearchElement = 10.0;
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
  )];

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
  )];
