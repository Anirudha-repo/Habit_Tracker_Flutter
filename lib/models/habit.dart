// lib/models/habit.dart
import 'package:flutter/material.dart';

class Habit {
  String name;
  List<bool> completed;
  int color;
  int iconCodePoint;
  bool reminder;

  Habit({
    required this.name,
    required this.completed,
    this.color = 0xFF3F51B5, // indigo
    this.iconCodePoint = 0xe5ca, // default icon codepoint
    this.reminder = false,
  });

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'completed': completed,
      'color': color,
      'iconCodePoint': iconCodePoint,
      'reminder': reminder,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      name: map['name'] as String,
      completed: List<bool>.from(map['completed'] as List),
      color: map['color'] ?? 0xFF3F51B5,
      iconCodePoint: map['iconCodePoint'] ?? 0xe5ca,
      reminder: map['reminder'] ?? false,
    );
  }
}
