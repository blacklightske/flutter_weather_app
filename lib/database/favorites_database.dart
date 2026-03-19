import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/favorite_city.dart';

class FavoritesDatabase {
  static final FavoritesDatabase instance = FavoritesDatabase._init();

  static Database? _database;

  FavoritesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('weather_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT NOT NULL,
        country TEXT NOT NULL,
        lat REAL NOT NULL,
        lon REAL NOT NULL,
        savedAt INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertFavorite(FavoriteCity favorite) async {
    print('FavoritesDatabase.insertFavorite called');

    final db = await instance.database;

    final insertedId = await db.insert('favorites', favorite.toMap());

    print('Inserted row id: $insertedId');

    return insertedId;
  }

  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await instance.database;

    return await db.query('favorites', orderBy: 'savedAt DESC');
  }
}
