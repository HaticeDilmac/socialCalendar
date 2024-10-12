import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
  final Function onSave;

  AddFriendScreen({required this.onSave});

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String name = '';
  DateTime? birthday;
  List<Map<String, dynamic>> importantDates = [];
  List<Map<String, dynamic>> interactionLog = [];

  final _formKey = GlobalKey<FormState>();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != birthday) {
      setState(() {
        birthday = picked;
      });
    }
  }

  void _addImportantDate() {
    String title = '';
    DateTime? date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Önemli Tarih Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(labelText: 'Başlık'),
              ),
              TextField(
                onTap: () async {
                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                },
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tarih'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (date != null) {
                  setState(() {
                    importantDates.add({'title': title, 'date': date!.toIso8601String()});
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _addInteractionLog() {
    String type = '';
    DateTime? date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Etkileşim Kaydı Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => type = value,
                decoration: const InputDecoration(labelText: 'Etkileşim Tipi'),
              ),
              TextField(
                onTap: () async {
                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                },
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tarih'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (date != null) {
                  setState(() {
                    interactionLog.add({'type': type, 'date': date!.toIso8601String()});
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (birthday != null) {
        widget.onSave(
          name,
          birthday!,
          importantDates,
          interactionLog,
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Arkadaş Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir isim girin';
                  }
                  return null;
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      birthday != null
                          ? 'Doğum Günü: ${birthday!.toLocal().toString().split(' ')[0]}'
                          : 'Doğum Günü Seçin',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Tarih Seç'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addImportantDate,
                child: const Text('Önemli Tarih Ekle'),
              ),
              ElevatedButton(
                onPressed: _addInteractionLog,
                child: const Text('Etkileşim Kaydı Ekle'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
