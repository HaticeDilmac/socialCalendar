import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_calendar/pages/friendsManager.dart';
import '../model/friends.dart';
import 'package:http/http.dart' as http;

import '../widget/customElevatedbutton.dart'; // Takvim için gerekli kütüphane

class AddFriendScreen extends StatefulWidget {
  final Friend? existingFriend;

  const AddFriendScreen({super.key, this.existingFriend});

  @override
  // ignore: library_private_types_in_public_api
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String name = '';
  DateTime? birthday;
  List<ImportantDate> importantDates = [];
  List<InteractionLog> interactionLog = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingFriend != null) {
      nameController.text = widget.existingFriend!.name;
      birthday = widget.existingFriend!.birthday;
      importantDates = widget.existingFriend!.importantDates;
      interactionLog = widget.existingFriend!.interactionLog;
    }
  }

//add friend api call function
  void addFriend(String name, DateTime birthday) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/friends'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
    );

    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const FriendListScreen()),
      );
    } else {
      // Handle error
    }
  }

//update friend api call function
  void updateFriend(
    String name,
    DateTime birthday,
    String id,
    List<ImportantDate> importantDates,
    List<InteractionLog> interactionLog,
  ) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/friends/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'birthday': birthday.toIso8601String(),
        'importantDates': importantDates
            .map((date) => {
                  'title': date.title,
                  'date': date.date.toIso8601String(),
                })
            .toList(),
        'interactionLog': interactionLog
            .map((log) => {
                  'type': log.type,
                  'date': log.date.toIso8601String(),
                })
            .toList(),
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const FriendListScreen()),
      );
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  void _selectDate(BuildContext context, {required bool isImportant}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      if (isImportant) {
        _addImportantDate(picked);
      } else {
        _addInteractionLog(picked);
      }
    }
  }

  void _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthday = picked;
      });
    }
  }

  void _addImportantDate(DateTime date) {
    String title = '';
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Add Important Date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                placeholder: 'Title',
                onChanged: (value) => title = value,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    importantDates.add(ImportantDate(title: title, date: date));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a title')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addInteractionLog(DateTime date) {
    String type = '';
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Add Interaction Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                placeholder: 'Interaction Type',
                onChanged: (value) => type = value,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                if (type.isNotEmpty) {
                  setState(() {
                    interactionLog.add(InteractionLog(type: type, date: date));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a type')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (birthday != null && nameController.text.isNotEmpty) {
        Friend newFriend = Friend(
          id: widget.existingFriend?.id ?? DateTime.now().toString(),
          name: nameController.text,
          birthday: birthday!,
          importantDates: importantDates,
          interactionLog: interactionLog,
        );

        widget.existingFriend != null
            ? updateFriend(newFriend.name, newFriend.birthday,
                widget.existingFriend!.id, importantDates, interactionLog)
            : addFriend(newFriend.name, newFriend.birthday);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name and Birthday are required.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingFriend == null
              ? 'Add New Friend'
              : 'Edit Friend Information',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              nameFieldMethod(),
              const SizedBox(height: 16),
              Row(
                children: [
                  CustomElevatedButton(
                    text: 'Choose Birthday',
                    onPressed: () => _selectBirthday(context),
                  ),
                  const SizedBox(width: 5),
                  CustomElevatedButton(
                    text: 'Add Important Day',
                    onPressed: () => _selectDate(context, isImportant: true),
                  ),
                  const SizedBox(width: 5),
                  CustomElevatedButton(
                    text: 'Add Interaction Record',
                    onPressed: () => _selectDate(context, isImportant: false),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                birthday != null
                    ? 'Birthday: ${DateFormat('d MMMM yyyy').format(birthday!.toLocal())}'
                    : '',
              ),
              const SizedBox(height: 10),

              // Important Dates List
              if (importantDates.isNotEmpty) ...[
                const Text(
                  'Important Dates:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: importantDates.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(importantDates[index].title),
                        subtitle: Text(
                          DateFormat('d MMMM yyyy')
                              .format(importantDates[index].date.toLocal()),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
              ],

              // Interaction Logs List
              if (interactionLog.isNotEmpty) ...[
                const Text(
                  'Interaction Records:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: interactionLog.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(interactionLog[index].type),
                        subtitle: Text(DateFormat('d MMMM yyyy')
                            .format(interactionLog[index].date.toLocal())),
                      );
                    },
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
              ],

              const Spacer(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 80),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField nameFieldMethod() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
      onChanged: (value) {},
    );
  }
}
