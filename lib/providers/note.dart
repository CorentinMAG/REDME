import 'package:flutter/material.dart';
import 'package:redme/models/note.dart';
import 'package:redme/services/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  List<Note> _archivedNotes = [];
  final NoteService noteService = NoteService();
  bool _isSelectMode = false;
  bool _isArchiveMode = false;

  List<Note> get notes => _filteredNotes;
  bool get isSelectMode => _isSelectMode;
  bool get isArchived => _isArchiveMode;
  List<Note> get archived => _archivedNotes;

  NoteProvider() {
    _loadNotesFromDB();
  }

  Future<void> _loadNotesFromDB() async {
    List<Note> notes = await noteService.fetchAll();
    _notes.addAll(notes.where((n) => !n.isArchived).toList());
    _archivedNotes.addAll(notes.where((n) => n.isArchived).toList());
    sortByLastUpdated();
    _filteredNotes = List.from(_notes);
    notifyListeners();
  }

  Future<void> create(Note note) async {
    final id = await noteService.create(note);
    final newNote = note.copyWith(id: id);
    _notes.insert(0, newNote);
    _filteredNotes.insert(0, newNote);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await noteService.delete(id);
    _notes.removeWhere((note) => note.id == id);
    _filteredNotes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  Future<void> deleteAll() async {
    final notes = _filteredNotes.where((n) => n.isSelected).toList();
    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      await noteService.delete(note.id!);
      _notes.removeWhere((n) => note.id == n.id);
      _filteredNotes.removeWhere((n) => note.id == n.id);
    }
    notifyListeners();
  }

  Future<void> archiveAll() async {
    final notes = _filteredNotes.where((n) => n.isSelected).toList();
    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      note.isArchived = true;
      await noteService.update(note);
      _notes.removeWhere((n) => note.id == n.id);
      _filteredNotes.removeWhere((n) => note.id == n.id);
      _archivedNotes.insert(0, note);
    }
    notifyListeners();
  }

  Future<void> update(Note note) async {
    await noteService.update(note);
    if (_isArchiveMode) {
      final idx = _archivedNotes.indexWhere((n) => n.id == note.id);
      if (idx != -1) {
        _filteredNotes[idx] = note;
        final filteredIdx = _filteredNotes.indexWhere((n) => n.id == note.id);
        if (filteredIdx != -1) {
          _filteredNotes[filteredIdx] = note;
        }
        notifyListeners();
      }

    } else {
      final idx = _notes.indexWhere((n) => n.id == note.id);
      if (idx != -1) {
        _notes[idx] = note;
        final filteredIdx = _filteredNotes.indexWhere((n) => n.id == note.id);
        if (filteredIdx != -1) {
          _filteredNotes[filteredIdx] = note;
        }
        notifyListeners();
      }
    }
  }

  void filter(String searchText) {
    final searchTextlow = searchText.toLowerCase();

    if (_isArchiveMode) {
       _filteredNotes = _archivedNotes.where((note) {
          final title = note.title;
          final content = note.content;

          return title.contains(searchTextlow) || content.contains(searchTextlow);
        }).toList();

    } else {
      _filteredNotes = _notes.where((note) {
        final title = note.title;
        final content = note.content;

        return title.contains(searchTextlow) || content.contains(searchTextlow);
    }).toList();

    }
    notifyListeners();
  }

  Future<void> archive(Note note) async {
    note.isArchived = true;
    await noteService.update(note);
    _notes.removeWhere((n) => n.id == note.id);
    _filteredNotes.removeWhere((n) => n.id == note.id);
    _archivedNotes.insert(0, note);
    notifyListeners();
  }

  Future<void> unarchive(Note note) async {
    note.isArchived = false;
    await noteService.update(note);
    _archivedNotes.removeWhere((n) => n.id == note.id);
    _filteredNotes.removeWhere((n) => n.id == note.id);
    _notes.insert(0, note);
    notifyListeners();
  }

  void toggleSelectMode() {
    _filteredNotes.forEach((n) => n.isSelected = false);
    _isSelectMode = !_isSelectMode;
    notifyListeners();
  }

  void toggleArchiveMode() {
    _isArchiveMode = !_isArchiveMode;

    if (_isArchiveMode) {
      _filteredNotes = _archivedNotes;
    } else {
      _filteredNotes = _notes;
    }
    notifyListeners();
  }

  int get selected {
    final notes = _filteredNotes.where((n) => n.isSelected);
    return notes.length;
  } 

  void sortByLastUpdated({bool reverse = false}) {
    if (reverse) {
      _filteredNotes.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    } else {
      _filteredNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    notifyListeners();
  }

  void toggleSelected(Note note) {
    note.isSelected = !note.isSelected;
    notifyListeners();
  }
}