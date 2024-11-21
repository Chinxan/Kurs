import 'package:flutter/material.dart';
import 'habit.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddHabitScreen extends StatefulWidget {
  final Function(Habit) onAddHabit;

  AddHabitScreen({required this.onAddHabit});

  @override
  AddHabitScreenState createState() => AddHabitScreenState();
}

class AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  Color _selectedColor = Colors.red;

  void submit() {
    final String name = _nameController.text;
    final String goal = _goalController.text;

    if (name.isNotEmpty && goal.isNotEmpty) {
      final newHabit = Habit(
        name: name,
        currentGoal: goal,
        color: _selectedColor,
        startDate: DateTime.now(),
      );
      widget.onAddHabit(newHabit);
      Navigator.of(context).pop();
    }
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Выберите цвет'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить привычку')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Название привычки'),
            ),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: 'Текущая цель'),
              keyboardType: TextInputType.number, 
            ),
            SizedBox(height: 20),
            Text('Выбранный цвет:'),
            GestureDetector(
              onTap: pickColor,
              child: CircleAvatar(
                backgroundColor: _selectedColor,
                radius: 30,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}