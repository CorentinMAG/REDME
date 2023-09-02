import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "redme.db"),
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      version: 1
      );
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE note("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "title TEXT,"
        "content TEXT,"
        "isArchived INTEGER,"
        "isImportant INTEGER,"
        "color INTEGER,"
        "createdAt INTEGER,"
        "updatedAt INTEGER)"
    );
    await db.execute("CREATE TABLE task("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "date TEXT,"
        "content TEXT,"
        "isAlarm INTEGER,"
        "isTicked INTEGER,"
        "createdAt TEXT,"
        "updatedAt TEXT)"
    );

  }

  static Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE note');
    await db.execute('DROP TABLE task');
    await onCreate(db, newVersion);
  }
}