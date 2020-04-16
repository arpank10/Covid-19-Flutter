import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");

    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE country (
              country TEXT PRIMARY KEY,
              slug TEXT NOT NULL,
              iso2 TEXT NOT NULL,
              newConfirmed INT NOT NULL,
              totalConfirmed INT NOT NULL,
              newDeaths INT NOT NULL,
              totalDeaths INT NOT NULL,
              newRecovered INT NOT NULL,
              totalRecovered INT NOT NULL
              )""");

    await populateCountries();
  }

  Future populateCountries() async{
    //Populate using countries.json
  }


}