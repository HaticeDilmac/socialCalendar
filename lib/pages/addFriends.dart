import 'package:flutter/material.dart';

import '../model/friends.dart';

class AddFriendScreen extends StatefulWidget {
  final Function onSave;
  final Friend? existingFriend; // Accepts an existing Friend model for editing

  AddFriendScreen({
    required this.onSave,
    this.existingFriend,
  });

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String name = '';
  DateTime? birthday;
  List<ImportantDate> importantDates = [];
  List<InteractionLog> interactionLog = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.existingFriend != null) {
      // Initialize fields with existing friend data
      name = widget.existingFriend!.name;
      birthday = widget.existingFriend!.birthday;
      importantDates = widget.existingFriend!.importantDates;
      interactionLog = widget.existingFriend!.interactionLog;
    }
  }

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
                    importantDates.add(ImportantDate(title: title, date: date!));
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
                    interactionLog.add(InteractionLog(type: type, date: date!));
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
        // Create a new Friend object
        Friend newFriend = Friend(
          id: widget.existingFriend?.id ?? DateTime.now().toString(),
          name: name,
          birthday: birthday!,
          importantDates: importantDates,
          interactionLog: interactionLog,
        );

        widget.onSave(newFriend); // Pass the entire Friend object
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
                initialValue: name, // Set initial value for editing
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
