import 'dart:async';
import 'dart:convert';

import 'package:covid/Database/cases.dart';
import 'package:covid/Database/database_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Database/country.dart';

const BASE_URL = "https://api.covid19api.com/";
const BASE2_URL = "https://corona.lmao.ninja/";

//ALL COUNTRY DATA
const summary = "summary";
const globalData = "v2/historical/all?lastdays=";
const countryWise = "v2/historical/";
//example v2/historical/iso2?lastdays=30

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


Future<CaseStat> fetchDataByCountry(Country country, int numberOfDays) async {
  if(country == null || country.slug == 'global'){
    return fetchGlobalData(numberOfDays);
  }
  final requestUrl = BASE2_URL + countryWise + country.iso2 + "?lastdays=" + numberOfDays.toString();
  final response = await http.get(requestUrl);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    CaseStat caseStat = new CaseStat(country.country, country.iso2);
    var infectedObject = jsonDecode(response.body)['timeline']['cases'] as Map;
    var recoveredObject = jsonDecode(response.body)['timeline']['recovered'] as Map;
    var deceasedObject = jsonDecode(response.body)['timeline']['deaths'] as Map;
    for (final k in infectedObject.keys) {
      final infected = int.parse(infectedObject[k].toString());
      final deceased = int.parse(deceasedObject[k].toString());
      final recovered = int.parse(recoveredObject[k].toString());
      final active = infected - deceased - recovered;

      CaseCount caseCount = new CaseCount();
      caseCount.date = k;
      caseCount.infected = infected;
      caseCount.deceased = deceased;
      caseCount.recovered = recovered;
      caseCount.active = active;
      caseStat.cases.add(caseCount);
    }
    return caseStat;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed Request, Check your internet Connection');
  }

}


Future<CaseStat> fetchGlobalData(int numberOfDays) async {
  final requestUrl = BASE2_URL + globalData + numberOfDays.toString();
  final response = await http.get(requestUrl);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    CaseStat caseStat = new CaseStat("Global", "WL");
    var infectedObject = jsonDecode(response.body)['cases'] as Map;
    var recoveredObject = jsonDecode(response.body)['recovered'] as Map;
    var deceasedObject = jsonDecode(response.body)['deaths'] as Map;
    for (final k in infectedObject.keys) {
      final infected = int.parse(infectedObject[k].toString());
      final deceased = int.parse(deceasedObject[k].toString());
      final recovered = int.parse(recoveredObject[k].toString());
      final active = infected - deceased - recovered;

      CaseCount caseCount = new CaseCount();
      caseCount.date = k;
      caseCount.infected = infected;
      caseCount.deceased = deceased;
      caseCount.recovered = recovered;
      caseCount.active = active;
      caseStat.cases.add(caseCount);
    }
    return caseStat;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed Request, Check your internet Connection');
  }

}
