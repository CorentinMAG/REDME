import 'package:redme/models/note.dart';
import 'package:redme/repositories/note.dart';

class NoteService {
  final noteRepository = NoteRepository();

  Future<List<Note>> fetchAll() => noteRepository.fetchAll();

  Future<int> create(Note note) => noteRepository.create(note);

  Future<int> update(Note note) => noteRepository.update(note);

  Future<int> delete(int id) => noteRepository.delete(id);
}