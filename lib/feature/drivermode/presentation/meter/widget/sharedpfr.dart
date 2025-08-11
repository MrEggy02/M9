import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/feature/drivermode/presentation/meter/widget/convert_latlng.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Sharedpfr {
  static Database? _database;

  // Initialize database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Create and initialize database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'positions_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE positions(id INTEGER PRIMARY KEY AUTOINCREMENT, position_data TEXT)',
        );
      },
    );
  }

  // Save positions to SQLite
  static Future<bool> savePoly(List<Position> positions) async {
    try {
      final db = await database;

      // Convert positions to a list of maps
      List positionMaps = positions.map((e) => fromLatlng(e)).toList();

      // Convert to JSON string
      String positionsJson = jsonEncode(positionMaps);

      // Clear existing data
      await db.delete('positions');

      // Insert all positions as a single JSON string
      // This approach stores all positions in one record for simplicity
      await db.insert('positions', {'position_data': positionsJson});

      return true;
    } catch (e) {
      print('Error saving positions to SQLite: $e');
      return false;
    }
  }

  // Clear all stored positions
  static Future<void> clear() async {
    try {
      final db = await database;
      await db.delete('positions');
      await HiveDatabase.clearTime();
    } catch (e) {
      print('Error clearing positions from SQLite: $e');
    }
  }

  // Retrieve positions from SQLite
  static Future<List> getPoly() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db.query('positions');

      if (results.isEmpty || results[0]['position_data'] == null) {
        return [];
      }

      String positionsJson = results[0]['position_data'] as String;
      List positionMaps = jsonDecode(positionsJson);

      return positionMaps.map((e) => toLatlng(e)).toList();
    } catch (e) {
      print('Error retrieving positions from SQLite: $e');
      return [];
    }
  }

  // Add a single position to the existing list
  static Future<bool> addPosition(Position position) async {
    try {
      // Get current positions
      List currentPositions = await getPoly();
      List<Position> positions =
          currentPositions.map((e) => e['position'] as Position).toList();

      // Add new position
      positions.add(position);

      // Save updated list
      return await savePoly(positions);
    } catch (e) {
      print('Error adding position to SQLite: $e');
      return false;
    }
  }
}
