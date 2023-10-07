import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "redme.db"),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
      version: 5
      );
  }

  static Future<void> _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE note("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "title TEXT,"
        "content TEXT,"
        "isArchived INTEGER,"
        "color INTEGER,"
        "reminderTime INTEGER,"
        "createdAt INTEGER,"
        "updatedAt INTEGER)"
    );
    await db.execute("CREATE TABLE task("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "content TEXT,"
        "isCompleted INTEGER,"
        "isArchived INTEGER,"
        "color INTEGER,"
        "createdAt INTEGER,"
        "updatedAt INTEGER,"
        "parentId INTEGER,"
        "FOREIGN KEY(parentId) REFERENCES task(id) ON DELETE CASCADE)"
    );
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE note');
    await db.execute('DROP TABLE task');
    await _onCreate(db, newVersion);
  }
}