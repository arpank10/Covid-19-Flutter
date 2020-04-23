import 'dart:async';

import 'package:covid/Database/database_client.dart';
import 'package:covid/Helpers/api.dart';
import 'package:covid/Widgets/home.dart';
import 'package:covid/Widgets/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  final API api = new API();


  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = prefs.getBool('firstTime') ?? false;

    if (_seen) {
      api.fetchAllStats();
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new Home()));
    } else {
      await prefs.setBool('firstTime', true);
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new OnboardScreens()));
    }
  }


  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}