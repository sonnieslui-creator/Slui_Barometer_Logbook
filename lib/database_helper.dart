import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('barometer.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE measurements(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        pressure REAL,
        temperature REAL,
        humidity REAL
      )
    ''');
  }

  Future<int> insertMeasurement(
    Map<String, dynamic> row,
  ) async {
    final db = await database;
    return await db.insert(
      'measurements',
      row,
    );
  }

  Future<List<Map<String, dynamic>>>
      getMeasurements() async {
    final db = await database;

    return await db.query(
      'measurements',
      orderBy: 'id DESC',
    );
  }
}