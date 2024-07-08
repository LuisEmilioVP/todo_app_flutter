import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() {
    return _instance;
  }

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_app.db');

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize sqflite_common_ffi for desktop environments
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // For mobile platforms, sqflite is used by default

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, username TEXT UNIQUE, password TEXT)',
    );

    await db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES users(id))',
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
