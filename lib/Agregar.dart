import 'package:flutter/material.dart';
import 'package:flutter_proyecto_recordatorios/main.dart';

class AddReminderScreen extends StatefulWidget {
  final Function(Reminder) onAddReminder;

  AddReminderScreen({required this.onAddReminder});

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late String formattedDateTime = '';
  String title = '';
  DateTime dateTime = DateTime(2023, 12, 15, 5, 30);
  String? voiceNote;

  @override
  void initState() {
    super.initState();
    // Inicializar el plugin en initState
  }

  Widget build(BuildContext context) {
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
                setState(() {
                  title = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              'Fecha y Hora: $formattedDateTime',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Seleccionar Fecha y Hora'),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 210, 203, 201)),
              onPressed: pickDateTime,
            ),
            const SizedBox(height: 400.0),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  Reminder newReminder = Reminder(
                    id: DateTime.now()
                        .millisecondsSinceEpoch, // Genera un ID único basado en la marca de tiempo
                    title: title,
                    date: formattedDateTime,
                    dateTime: dateTime,
                  );
                  widget.onAddReminder(newReminder);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              child: const Text(
                'Añadir',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Reproducir Nota de Voz'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickDateTime() async {
    DateTime? pickedDate = await pickDate();
    if (pickedDate == null) return;
    TimeOfDay? pickedTime = await pickTime();
    if (pickedTime == null) return;

    setState(() {
      dateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      formattedDateTime =
          '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2023),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}
