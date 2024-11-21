import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'habit.dart';
import 'habit_detail_screen.dart';
import 'about_page.dart';
import 'dart:async';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Отказ от вредных привычек',
      theme: ThemeData.dark(),
      home: HabitListScreen(),
    );
  }
}

class HabitListScreen extends StatefulWidget {
  @override
  HabitListScreenState createState() => HabitListScreenState();
}

class HabitListScreenState extends State<HabitListScreen> {
  final List<Habit> habits = [];
  String searchQuery = '';
  Timer? timer;

  void addHabit(Habit habit) {
    setState(() {
      habits.add(habit);
    });
    startTimer(habit); 
  }

  void startTimer(Habit habit) {
   
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        habit.updateElapsedTime(Duration(seconds: 1)); 
      });
    });
  }

  void deleteHabit(Habit habit) {
    setState(() {
      habits.remove(habit);
    });
  }

  @override
  void dispose() {
    timer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredHabits = habits.where((habit) => habit.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/a.png', 
              width: 64,
              height: 64, 
            ),
            SizedBox(width: 10), 
            Text('Отказ от вредных привычек'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHabits.isEmpty ? 1 : filteredHabits.length,
              itemBuilder: (context, index) {
                if (filteredHabits.isEmpty) {
                  return Center(child: Text('Ничего не найдено'));
                }
                return Card(
                  margin: EdgeInsets.all(10),
                  color: filteredHabits[index].color, 
                  child: ListTile(
                    title: Text(filteredHabits[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Попытки: ${filteredHabits[index].attempts}'),
                        Text('Рекорд : ${filteredHabits[index].record} дней'),
                        Text('Прошло времени: ${filteredHabits[index].elapsedTime.inDays} дн. ${filteredHabits[index].elapsedTime.inHours.remainder(24)} ч. ${filteredHabits[index].elapsedTime.inMinutes.remainder(60)} мин. ${filteredHabits[index].elapsedTime.inSeconds.remainder(60)} сек.'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitDetailScreen(
                            habit: filteredHabits[index],
                            onDelete: deleteHabit,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddHabitDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddHabitDialog(BuildContext context) {
    String name = '';
    DateTime date = DateTime.now();
    Color color = Colors.red;
    String currentGoal = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить привычку'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Название'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 10),
                Text('Дата начала: ${date.toLocal()}'.split(' ')[0]),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null && selectedDate != date) {
                      setState(() {
                        date = selectedDate;
                      });
                    }
                  },
                  child: Text('Выбрать дату'),
                ),
                SizedBox(height: 10),
                Text('Выберите цвет'),
                BlockPicker(
                  pickerColor: color,
                  onColorChanged: (newColor) {
                    color = newColor;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Текущая цель'),
                  onChanged: (value) {
                    currentGoal = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                addHabit(Habit(name: name, startDate: date, color: color, currentGoal: currentGoal));
                Navigator.of(context).pop();
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}