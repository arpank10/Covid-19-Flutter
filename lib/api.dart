import 'dart:async';
import 'dart:convert';

import 'package:covid/Database/database_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Database/country.dart';

const BASE_URL = "https://api.covid19api.com/";

//ALL COUNTRY DATA
const summary = "summary";


Future<void> fetchAllStats() async {
  final response = await http.get(BASE_URL+summary);
  final DatabaseClient db = DatabaseClient.instance;

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Country global = new Country();
    global.country = "Global";
    global.slug = "global";
    global.iso2 = "WL";

    var globalObject = jsonDecode(response.body)['Global'];
    global.newConfirmed = globalObject['NewConfirmed'];
    global.totalConfirmed = globalObject['TotalConfirmed'];
    global.newDeaths = globalObject['NewDeaths'];
    global.totalDeaths = globalObject['TotalDeaths'];
    global.newRecovered = globalObject['NewRecovered'];
    global.totalRecovered = globalObject['TotalRecovered'];


    var countryObjects = jsonDecode(response.body)['Countries'] as List;

    List<Country> countries = countryObjects.map((countryJson) => Country.fromJsonData(countryJson)).toList();
    countries.add(global);

    countries.forEach((element) async {
      db.updateCountry(element);
//      print(element.slug);
    });
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
