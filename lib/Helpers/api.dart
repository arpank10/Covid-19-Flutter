import 'dart:async';
import 'dart:convert';

import 'package:covid/Database/cases.dart';
import 'package:covid/Database/database_client.dart';
import 'package:covid/Helpers/api_helper.dart';
import 'package:covid/Helpers/app_exceptions.dart';

import '../Database/country.dart';
import 'file:///E:/Android/Self/covid/lib/Helpers/constants.dart';




class API {
  final ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();

  API();

  Future<void> fetchAllStats() async {
    try{
      final responseBody = await _apiBaseHelper.get(BASE_URL+summary);
      final DatabaseClient db = DatabaseClient.instance;

      Country global = new Country();
      global.country = "Global";
      global.slug = "global";
      global.iso2 = "WL";

      var globalObject = jsonDecode(responseBody)['Global'];
      global.newConfirmed = globalObject['NewConfirmed'];
      global.totalConfirmed = globalObject['TotalConfirmed'];
      global.newDeaths = globalObject['NewDeaths'];
      global.totalDeaths = globalObject['TotalDeaths'];
      global.newRecovered = globalObject['NewRecovered'];
      global.totalRecovered = globalObject['TotalRecovered'];


      var countryObjects = jsonDecode(responseBody)['Countries'] as List;

      List<Country> countries = countryObjects.map((countryJson) => Country.fromJsonData(countryJson)).toList();
      countries.add(global);

      countries.forEach((element) async {
        db.updateCountry(element);
      });

    } on AppException {
      throw Failure("Please try again.");
    }
  }

  Future<CaseStat> fetchDataByCountry(Country country, int numberOfDays) async {
    try{
      if(country == null || country.slug == 'global'){
        return fetchGlobalData(numberOfDays);
      }
      final requestUrl = BASE2_URL + countryWise + country.iso2 + "?lastdays=" + numberOfDays.toString();
      final responseBody = await _apiBaseHelper.get(requestUrl);

      CaseStat caseStat = new CaseStat(country.country, country.iso2);
      var infectedObject = jsonDecode(responseBody)['timeline']['cases'] as Map;
      var recoveredObject = jsonDecode(responseBody)['timeline']['recovered'] as Map;
      var deceasedObject = jsonDecode(responseBody)['timeline']['deaths'] as Map;
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

    } on AppException {
      throw Failure("Please try again.");
    }
  }


  Future<CaseStat> fetchGlobalData(int numberOfDays) async {
    try{
      final requestUrl = BASE2_URL + globalData + numberOfDays.toString();
      final responseBody = await _apiBaseHelper.get(requestUrl);

      CaseStat caseStat = new CaseStat("Global", "WL");
      var infectedObject = jsonDecode(responseBody)['cases'] as Map;
      var recoveredObject = jsonDecode(responseBody)['recovered'] as Map;
      var deceasedObject = jsonDecode(responseBody)['deaths'] as Map;
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

    } on AppException {
      throw Failure("Please try again.");
    }
  }
}

class Failure{
  final String _message;

  Failure(this._message);

  @override
  String toString() {
    // TODO: implement toString
    return this._message;
  }

}