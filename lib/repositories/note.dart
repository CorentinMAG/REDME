import 'package:redme/exceptions/note.dart';
import 'package:redme/models/note.dart';
import 'package:redme/db/db.dart';
import 'package:sqflite/sqflite.dart';

class NoteRepository {

  Future<int> create(Note note) async{
    if (note.id != null) throw NoteException("Note has an id");

    Database db = await DatabaseManager.initializeDB();
    final id = await db.insert('note', note.toMap3(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> delete(int id) async {
    Database db = await DatabaseManager.initializeDB();
    var result = db.delete("note", where: "id=?", whereArgs: [id]);
    return result;
  }

  Future<int> update(Note note) async {
    if (note.id == null) throw NoteException("Note has no id");

    Database db = await DatabaseManager.initializeDB();
    var result = db.update("note", note.toMap3(), where: "id=?", whereArgs: [note.id]);
    return result;
  }

  Future<List<Note>> fetchAll() async {
    Database db = await DatabaseManager.initializeDB();

    List<Map<String, dynamic>> maps = await db.query("note");
    List<Note> notes = maps.map((e) => Note.fromDatabase3(e)).toList();

    return notes;
  }
}