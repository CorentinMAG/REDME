import 'package:flutter/material.dart';

class Note {
  int? id;
  String title;
  String content;
  bool isArchived;
  bool isSelected;
  int color;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? reminderTime;

  Note({
    this.id,
    required this.title, 
    required this.content, 
    this.isArchived = false, 
    this.isSelected = false,
    this.reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? color
    }): 
    color = color ?? Colors.white.value,
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  factory Note.fromDatabase3(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      title: map["title"],
      content: map["content"],
      isArchived: map["isArchived"] == 1,
      color: map["color"],
      reminderTime: map["reminderTime"] != null ? DateTime.fromMillisecondsSinceEpoch(map["reminderTime"]).toLocal() : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]).toLocal(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map["updatedAt"]).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "isArchived": isArchived,
      "color": color,
      "reminderTime": reminderTime,
      "createdAt": createdAt,
      "updatedAt": updatedAt
    };
  }

  // create a copy of the current note with optional new values
  // cannot update reminderTime with this function, use the setter instead
  Note copyWith(
    {
      int? id,
      String? title, 
      String? content, 
      bool? isArchived, 
      int? color,
      DateTime? createdAt, 
      DateTime? updatedAt
    }
  ) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      reminderTime: reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }

  Map<String, dynamic> toMap3() {
    return {
      "title": title,
      "content": content,
      "isArchived": isArchived ? 1: 0,
      "color": color,
      "reminderTime": reminderTime?.toUtc().millisecondsSinceEpoch,
      "createdAt": createdAt.toUtc().millisecondsSinceEpoch,
      "updatedAt": updatedAt.toUtc().millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, isArchived: $isArchived, isSelected: $isSelected, color: $color, reminderTime: $reminderTime, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}