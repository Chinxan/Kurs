import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async'; // Для использования Timer
import 'habit.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final Function(Habit) onDelete;

  HabitDetailScreen({required this.habit, required this.onDelete});

  @override
  HabitDetailScreenState createState() => HabitDetailScreenState();
}

class HabitDetailScreenState extends State<HabitDetailScreen> {
  double completedDays = 0;
  double totalDays = 7;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startFillingChart();
  }

  void startFillingChart() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (completedDays < totalDays) {
        setState(() {
          completedDays += 1.0 / (totalDays * 10); // Увеличиваем заполнение медленно
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int completedDaysInt = completedDays.toInt();
    int remainingDays = totalDays.toInt() - completedDaysInt;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showEditDeleteOptions(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Процесс: ${widget.habit.elapsedTime.inDays} дн. ${widget.habit.elapsedTime.inHours.remainder(24)} ч. ${widget.habit.elapsedTime.inMinutes.remainder(60)} мин. ${widget.habit.elapsedTime.inSeconds.remainder(60)} сек.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: completedDays,
                          color: Colors.red,
                          title: '',
                          radius: 60,
                        ),
                        PieChartSectionData(
                          value: remainingDays.toDouble(),
                          color: Colors.white,
                          title: '',
                          radius: 60,
                        ),
                      ],
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                    ),
                  ),
                  Positioned(
                    right: 450, // Перемещение вправо
                    top: 60, // Перемещение выше центра
                    child: Text(
                      '7 дней',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Попытка: ${widget.habit.attempts}'),
                Text('Рекорд: ${widget.habit.record}'),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showRestartConfirmation(context);
                },
                child: Text('Рестарт'),
              ),
            ),
            SizedBox(height: 20), // Отступ после кнопки
            Container(
              height: 2.0, // Высота линии
              color: Colors.red, // Цвет линии
            ),
            SizedBox(height: 20), // Отступ после линии
            Text('История:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.habit.history.length,
                itemBuilder: (context, index) {
                  String historyEntry = widget.habit.history[index];
                  IconData iconData;

                  // Определяем иконку в зависимости от текста истории
                  if (historyEntry.startsWith('Рестарт')) {
                    iconData = Icons.refresh; // Иконка для рестарта
                  } else {
                    iconData = Icons.comment; // Иконка для комментария
                  }

                  return ListTile(
                    leading: Icon(iconData),
                    title: Text(historyEntry),
                  );
 },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addComment(context);
              },
              child: Text('Добавить Комментарий'),
            ),
          ],
        ),
      ),
    );
  }

  void editHabit(BuildContext context) {
    String newName = '';
    String newDescription = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактировать привычку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(hintText: "Новое имя привычки"),
              ),
              TextField(
                onChanged: (value) {
                  newDescription = value;
                },
                decoration: InputDecoration(hintText: "Новое описание привычки"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newName.isNotEmpty && newDescription.isNotEmpty) {
                  setState(() {
                    widget.habit.name = newName; // Обновляем имя привычки
                  });
                  Navigator.of(context).pop(); // Закрыть диалог
                }
              },
              child: Text('Сохранить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void showRestartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтверждение'),
        content: Text('Вы хотите начать путь с начала?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.habit.elapsedTime = Duration.zero;
                widget.habit.attempts += 1;
                widget.habit.history.add('Рестарт привычки');
              });
              Navigator.of(context).pop(); // Закрыть диалог
            },
            child: Text('Да'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Закрыть диалог
            },
            child: Text('Нет'),
          ),
        ],
      ),
    );
  }

  void addComment(BuildContext context) {
    String comment = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить комментарий'),
          content: TextField(
            onChanged: (value) {
              comment = value;
            },
            decoration: InputDecoration(hintText: "Введите ваш комментарий"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (comment.isNotEmpty) {
                  setState(() {
                    widget.habit.history.add(comment); 
                  });
                  Navigator.of(context).pop(); // Закрыть диалог
                }
              },
              child: Text('Добавить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void showEditDeleteOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Изменение'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                editHabit(context);
              },
              child: Text('Редактировать'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteHabit(context);
              },
              child: Text('Удалить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _deleteHabit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить эту привычку?'),
        actions: [
          TextButton(
            onPressed: () {
              widget.onDelete(widget.habit); // Вызов функции удаления
              Navigator.of(context).pop(); // Закрыть диалог
              Navigator.of(context).pop(); // Закрыть экран привычки
            },
            child: Text('Да'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Закрыть ди алог
            },
            child: Text('Нет'),
          ),
        ],
      ),
    );
  }
}