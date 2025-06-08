import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class DBHelper {
  DBHelper._();
  static final DBHelper dbh = DBHelper._();
  static Database? _database;
  static const _databaseVersion = 1;
  // static const table = 'indirimbo';
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initiateDatabase();
    return _database!;
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here.
  }

  Future onDowngrade(Database db, int oldVersion, int newVersion) async {
    // Handle database downgrades here.
  }

  _initiateDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      path.join(dbPath, 'incidentsDatabase.db'),
      onCreate: (db, version) async {
        await db.execute("""
  CREATE TABLE incidents(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL CHECK(LENGTH(title) >= 3 AND LENGTH(title) <= 25),
    description TEXT NOT NULL CHECK(LENGTH(description) >= 10 AND LENGTH(description) <= 250),
    category TEXT NOT NULL CHECK(category IN ('High priority', 'Priority', 'Low Priority')),
    location TEXT NOT NULL,
    dateTime TEXT NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('Open', 'Closed')),
    photo TEXT,
    UNIQUE(id)
  )
""");
      },
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
      version: _databaseVersion,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    Database db = await dbh.database;
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(String table, Map<String, dynamic> data,
      Map<String, Object> query) async {
    Database db = await dbh.database;
    List<Object> whereArgs = [];
    String where = '';
    for (var key in query.keys) {
      if (where != '') {
        where += ' AND $key = ?';
      } else {
        where += '$key = ?';
      }

      whereArgs.add(query[key]!);
    }

    await db.update(table, data, where: where, whereArgs: whereArgs);
    // await db.rawUpdate('UPDATE $table WHERE $query SET $columns', values);
  }

  static Future<List<Map<String, dynamic>>> simpleGet(String table) async {
    Database db = await dbh.database;
    return db.rawQuery('SELECT * FROM $table');
  }

  static Future<List<Map<String, dynamic>>> get(
      String table, Map<String, Object> params) async {
    Database db = await dbh.database;
    List<Object> values = [];
    String query = '';
    for (var key in params.keys) {
      if (query != '') {
        query += ' AND $key = ?';
      } else {
        query += '$key = ?';
      }

      values.add(params[key]!);
    }

    return db.rawQuery('SELECT * FROM $table WHERE $query', values);
  }

  static Future<List<Map<String, dynamic>>> delete(
      String table, Map<String, Object> params) async {
    Database db = await dbh.database;
    List<Object> values = [];
    String query = '';
    for (var key in params.keys) {
      if (query != '') {
        query += ' AND $key = ?';
      } else {
        query += '$key = ?';
      }

      values.add(params[key]!);
    }

    return db.rawQuery('DELETE FROM $table WHERE $query', values);
  }

  static Future<List<Map<String, dynamic>>> executeRawQuery(
      String query) async {
    Database db = await dbh.database;
    return db.rawQuery(query);
  }

  static Future<List<Map<String, dynamic>>> getAll(String table,
      {List<String>? cols}) async {
    Database db = await dbh.database;
    return cols == null ? db.query(table) : db.query(table, columns: cols);
  }

  static Future<void> closeDb() async {
    Database db = await dbh.database;
    await db.close();
  }

  static Future<void> deleteDb(String table) async {
    Database db = await dbh.database;
    await db.execute('DROP DATABASE $table');
  }

  static Future<int> deleteAll(String table, {int? param}) async {
    Database db = await dbh.database;
    return param == null
        ? db.rawDelete('DELETE FROM $table')
        : db.rawDelete('DELETE FROM $table WHERE id = ?', ['$param']);
  }

  static Future<int> numberOfEntries(String table, String cooperativeId) async {
    Database db = await dbh.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $table WHERE cooperativeId = $cooperativeId'))!;
  }

  static Future<int> getNextId(String table) async {
    Database db = await dbh.database;
    int nextId = Sqflite.firstIntValue(
            await db.rawQuery('SELECT MAX(id) + 1 FROM $table')) ??
        1;
    return nextId;
  }

  static Future<int?> getLowestBatchNo(String table) async {
    Database db = await dbh.database;
    var result = await db.rawQuery('SELECT MIN(batchNo) FROM $table');
    if (result[0]['MIN(batchNo)'] != null) {
      return result[0]['MIN(batchNo)'] as int;
    } else {
      return null;
    }
  }
}
