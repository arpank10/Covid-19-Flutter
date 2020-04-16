import 'package:flutter/cupertino.dart';

class Country {
  @required
  String country;
  @required
  String slug;
  @required
  String iso2;

  int newConfirmed;
  int totalConfirmed;
  int newDeaths;
  int totalDeaths;
  int newRecovered;
  int totalRecovered;

  Country();

  static final columns = [
    "country",
    "slug",
    "iso2",
    "newConfirmed",
    "totalConfirmed",
    "newDeaths",
    "totalDeaths",
    "newRecovered",
    "totalRecovered"];

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['country'] = country;
    map['slug'] = slug;
    map['iso2'] = iso2;
    map['newConfirmed'] = newConfirmed;
    map['totalConfirmed'] = totalConfirmed;
    map['newDeaths'] = newDeaths;
    map['totalDeaths'] = totalDeaths;
    map['newRecovered'] = newRecovered;
    map['totalRecovered'] = totalRecovered;
    return map;
  }

  static fromMap(Map map) {
    Country country = new Country();
    country.country = map['country'];
    country.slug = map['slug'];
    country.iso2 = map['iso2'];
    country.newConfirmed = map['newConfirmed'];
    country.totalConfirmed = map['totalConfirmed'];
    country.newDeaths = map['newDeaths'];
    country.totalDeaths = map['totalDeaths'];
    country.newRecovered = map['newRecovered'];
    country.totalRecovered = map['totalRecovered'];
    return country;
  }

  factory Country.fromJson(dynamic json) {
    Country country = new Country();
    country.country = json['Country'];
    country.slug = json['Slug'];
    country.iso2 = json['ISO2'];
    country.newConfirmed = 0;
    country.totalConfirmed = 0;
    country.newDeaths = 0;
    country.totalDeaths = 0;
    country.newRecovered = 0;
    country.totalRecovered = 0;
    return country;
  }

  factory Country.fromJsonData(dynamic json) {
    Country country = new Country();
    country.country = json['Country'];
    country.slug = json['Slug'];
    country.iso2 = json['CountryCode'];
    //Add id.
    country.newConfirmed = json['NewConfirmed'];
    country.totalConfirmed = json['TotalConfirmed'];
    country.newDeaths = json['NewDeaths'];
    country.totalDeaths = json['TotalDeaths'];
    country.newRecovered = json['NewRecovered'];
    country.totalRecovered = json['TotalRecovered'];
    return country;
  }

}