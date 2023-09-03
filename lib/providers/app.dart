import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isSelectedMode = false;
  bool _isArchiveMode = false;
  bool _isEditing = false;

  bool get isSelectedMode => _isSelectedMode;
  bool get isArchiveMode => _isArchiveMode;
  bool get isEditing => _isEditing;

  set isEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  void toggleSelectedMode() {
    _isSelectedMode = !_isSelectedMode;
    notifyListeners();
  }

  void toggleArchiveMode() {
    _isArchiveMode = !_isArchiveMode;
    notifyListeners();
  }

}