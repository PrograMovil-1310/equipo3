import 'package:flutter/material.dart';

void main() {
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

class AddReminderScreen extends StatelessWidget {
  final Function(Reminder) onAddReminder;

  AddReminderScreen({required this.onAddReminder});

  @override
  Widget build(BuildContext context) {
    String title = '';
    String date = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Recordatorio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Título'),
              onChanged: (value) {
                title = value;
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Fecha'),
              onChanged: (value) {
                date = value;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && date.isNotEmpty) {
                  Reminder newReminder = Reminder(title: title, date: date);
                  onAddReminder(newReminder);
                  Navigator.pop(context);
                }
              },
              child: const Text('Añadir Recordatorio'),
            ),
          ],
        ),
      ),
    );
  }
}

class Reminder {
  final String title;
  final String date;
  bool isCompleted;

  Reminder({
    required this.title,
    required this.date,
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
