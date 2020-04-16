import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:covid/Database/country.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';


//Make this singleton
class DatabaseClient {
  static Database _db;
  static String countryTableName = "country";


  DatabaseClient._privateConstructor();
  static final DatabaseClient instance = DatabaseClient._privateConstructor();

  // only have a single app-wide reference to the database
  Future<Database> get database async {
    if (_db != null) return _db;
    // lazily instantiate the db the first time it is accessed
    _db = await create();
    return _db;
  }


  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = Path.join(path.path, "database.db");
    print("Create called");
    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE country (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              country TEXT NOT NULL,
              slug TEXT NOT NULL,
              iso2 TEXT NOT NULL,
              newConfirmed INTEGER NOT NULL,
              totalConfirmed INTEGER NOT NULL,
              newDeaths INTEGER NOT NULL,
              totalDeaths INTEGER NOT NULL,
              newRecovered INTEGER NOT NULL,
              totalRecovered INTEGER NOT NULL
              )""");

  }

  Future<void> populateCountries(BuildContext context) async {
    await create();
    //Populate using countries.json
    String data = await DefaultAssetBundle.of(context).loadString("assets/countries.json");

    var countryObjects = jsonDecode(data) as List;
    List<Country> countries = countryObjects.map((countryJson) => Country.fromJson(countryJson)).toList();

    countries.forEach((element) async {
      await upsertCountry(element);
    });
  }

  Future<Country> upsertCountry(Country country) async {
    if(country.id == null){
      country.id = await _db.insert(countryTableName, country.toMap());
    }
    else {
      await _db.update(countryTableName, country.toMap(), where: "id = ?", whereArgs: [country.id]);
    }
    return country;
  }

  Future<Country> fetchCountry(int id) async {
    List<Map> results = await _db.query(countryTableName, columns: Country.columns, where: "id = ?", whereArgs: [id]);
    Country country = Country.fromMap(results[0]);

    return country;
  }

  Future<List<Country>> fetchAllCountries() async {
    List<Map> results = await _db.query(countryTableName, columns: Country.columns);
    List<Country> countries = new List();
    results.forEach((element) {
      Country country = Country.fromMap(element);
      countries.add(country);
    });

    return countries;
  }
}