import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ftltask/models/ToDo.dart';

import 'package:flutter_slidable/flutter_slidable.dart';




class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String ToDoTable = 'ToDo_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'ToDo.db';

    // Open/create the database at a given path
    var todoDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $ToDoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colDate TEXT)');
  }

  // Fetch Operation: Get all entry objects from database
  Future<List<Map<String, dynamic>>> getAllMapList() async
  {
    Database db = await this.database;

    var result = await db.query(ToDoTable, orderBy: '$colId DESC');

    return result;
  }

  // Insert Operation: Insert a ToDo object to database
  Future<int> insertData(var title, var description, var date) async
  {
    Database db = await this.database;
    Map<String, dynamic> data =
    {
      "title" : title,
      "description" : description,
      "date" : date,
    };
    var result = await db.insert(ToDoTable, data);
    return result;
  }
  Future<int> undo(var title, var description, var date, var id) async
  {
    Database db = await this.database;
    Map<String, dynamic> data =
    {
      "title" : title,
      "description" : description,
      "date" : date,
    };
    var result = await db.insert(ToDoTable, data);
    return result;
  }

  // Update Operation: Update a ToDo object and save it to database
  Future<int> updateData(var title, var description, var id) async
  {
    var db = await this.database;
    Map<String, dynamic> data =
    {
      "title" : title,
      "description" : description,
    };
    var result = await db.update(ToDoTable, data, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Delete Operation: Delete a ToDo object from database
  Future<int> deleteData(int id) async
  {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $ToDoTable WHERE $colId = $id');
    return result;
  }

  // Get number of ToDo objects in database
  Future<int> getCount() async
  {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $ToDoTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }





}