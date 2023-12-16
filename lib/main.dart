import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_proyecto_recordatorios/Agregar.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recordatorios',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ReminderListScreen(),
    );
  }
}

class ReminderListScreen extends StatefulWidget {
  @override
  _ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  List<Reminder> reminders = [];
  List<bool> selectedReminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Recordatorios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reminders[index].title),
            subtitle: Text(reminders[index].formattedDate()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReminderDetailsScreen(reminder: reminders[index])));
            },
            selected: selectedReminders[index],
            trailing: Checkbox(
              value: reminders[index].isCompleted,
              onChanged: (value) {
                setState(() {
                  reminders[index].isCompleted = value ?? false;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReminderScreen(
                onAddReminder: (Reminder newReminder) {
                  setState(() {
                    reminders.add(newReminder);
                    selectedReminders.add(false);
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Recordatorios'),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(
                reminders.length,
                (index) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return CheckboxListTile(
                        title: Text(reminders[index].title),
                        value: selectedReminders[index],
                        onChanged: (value) {
                          setState(() {
                            selectedReminders[index] = value ?? false;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedReminders();
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSelectedReminders() {
    for (int i = selectedReminders.length - 1; i >= 0; i--) {
      if (selectedReminders[i]) {
        setState(() {
          reminders.removeAt(i);
          selectedReminders.removeAt(i);
        });
      }
    }
  }
}

class Reminder {
  final int id;
  final String title;
  final String date;
  final DateTime dateTime;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.date,
    required this.dateTime,
    this.isCompleted = false,
  });

  String formattedDate() {
    return 'Fecha: $date';
  }
}

class ReminderDetailsScreen extends StatelessWidget {
  final Reminder reminder;

  ReminderDetailsScreen({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Recordatorio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título: ${reminder.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Fecha: ${reminder.date}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Completado: ${reminder.isCompleted ? 'Sí' : 'No'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
