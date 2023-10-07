import 'package:flutter/material.dart';

class Task {
  int? id;
  String content;
  bool isCompleted;
  bool isArchived;
  bool isSelected;
  int color;
  int? parentId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Task> subtasks;


  Task({
    this.id,
    required this.content,
    this.isCompleted = false,
    this.isArchived = false,
    this.isSelected = false,
    subtasks,
    this.parentId,
    int? color,
    DateTime? createdAt,
    DateTime? updatedAt
  }):
  color = color ?? Colors.white.value,
  subtasks = subtasks ?? [],
  createdAt = createdAt ?? DateTime.now(),
  updatedAt = updatedAt ?? DateTime.now();

  factory Task.fromDatabase3(Map<String, dynamic> map) {
    return Task(
      id: map["id"],
      content: map["content"],
      isCompleted: map["isCompleted"] == 1,
      isArchived: map["isArchived"] == 1,
      color: map["color"],
      parentId: map["parentId"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]).toLocal(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map["updatedAt"]).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "isCompleted": isCompleted,
      "isArchived": isArchived,
      "color": color,
      "parentId": parentId,
      "subtasks": subtasks,
      "createdAt": createdAt,
      "updatedAt": updatedAt
    };
  }

  Task copyWith(
    {
      int? id,
      String? content, 
      bool? isCompleted,
      bool? isArchived,
      int? color,
      int? parentId,
      List<Task>? subtasks,
      DateTime? createdAt, 
      DateTime? updatedAt
    }
  ) {
    return Task(
      id: id ?? this.id,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      parentId: parentId ?? this.parentId,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }

  Map<String, dynamic> toMap3() {
    return {
      "content": content,
      "isCompleted": isCompleted ? 1: 0,
      "isArchived": isArchived ? 1: 0,
      "color": color,
      "parentId": parentId,
      "createdAt": createdAt.toUtc().millisecondsSinceEpoch,
      "updatedAt": updatedAt.toUtc().millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, content: $content, isCompleted: $isCompleted, isArchived: $isArchived, isSelected: $isSelected, color: $color, parentId: $parentId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}