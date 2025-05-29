import 'package:flutter/foundation.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isDone;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isDone = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
    );
  }

  // for debugging.
  @override
  String toString() {
    return 'Task(id: $id, title: $title, desc: $description, createdAt: $createdAt, isDone: $isDone)';
  }
}
