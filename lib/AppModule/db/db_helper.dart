import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'product.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        ///-------- Product Table -------------///
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS products (
            productId INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT,
            brand TEXT,
            segment TEXT,
            productName TEXT
          )
          ''',
        ).catchError((e) {
          debugPrint('<---- error in creating product table ---> \n$e');
        });

        ///-------- Survey Table -------------///
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS survey (
            surveyId INTEGER PRIMARY KEY AUTOINCREMENT,
            surveyName TEXT,
            createdDate TEXT
          )
          ''',
        ).catchError((e) {
          debugPrint('<---- error in creating survey table ---> \n$e');
        });

        ///-------- Survey Detail Table -------------///
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS surveyDetail (
            surveyDetailId INTEGER PRIMARY KEY AUTOINCREMENT,
            surveyId INTEGER,
            productId INTEGER,
            quantity TEXT
          )
          ''',
        ).catchError((e) {
          debugPrint('<---- error in creating surveyDetail table ---> \n$e');
        });
      },
    );
  }
}

// FOREIGN KEY (surveyId) REFERENCES survey (surveyId),
// FOREIGN KEY (productId) REFERENCES products (productId),
