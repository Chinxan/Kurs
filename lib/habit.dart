import 'package:flutter/material.dart';


class Habit {
  String name; 
  DateTime startDate; 
  Color color; 
  int attempts;
  int record;
  String currentGoal; 
  Duration elapsedTime; 
  List<String> history;

  Habit({
    required this.name,
    required this.startDate,
    required this.color,
    this.attempts = 0,
    this.record = 0,
    required this.currentGoal,
  })  : elapsedTime = Duration.zero, 
        history = []; 


  void updateElapsedTime(Duration duration) {
    elapsedTime += duration;
  }
}
