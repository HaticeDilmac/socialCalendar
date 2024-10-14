import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/friends.dart';

class AddFriendScreen extends StatefulWidget {
  final Function(Friend) onSave;
  final Friend? existingFriend;

  const AddFriendScreen({
    super.key,
    required this.onSave,
    this.existingFriend,
  });

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

  @override
  void initState() {
    super.initState();
    if (widget.existingFriend != null) {
      name = widget.existingFriend!.name;
      birthday = widget.existingFriend!.birthday;
      importantDates = widget.existingFriend!.importantDates;
      interactionLog = widget.existingFriend!.interactionLog;
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
                Navigator.of(context).pop(); // İptal etmek için
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
                Navigator.of(context).pop(); // İptal etmek için
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
                  // Kullanıcı bir tür girmediğinde uyarı
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
      if (birthday != null) {
        Friend newFriend = Friend(
          id: widget.existingFriend?.id ?? DateTime.now().toString(),
          name: name,
          birthday: birthday!,
          importantDates: importantDates,
          interactionLog: interactionLog,
        );

        widget.onSave(newFriend);
        Navigator.of(context).pop();
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
                    onPressed: () => _selectBirthday(
                      context,
                    ),
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
              const SizedBox(
                height: 10,
              ),
              Text(
                birthday != null
                    ? 'Birthday: ${DateFormat('d MMMM yyyy').format(birthday!.toLocal())}'
                    : '',
              ),
              const SizedBox(
                height: 10,
              ),

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
                  backgroundColor: Colors.black, // Buton arkaplanı siyah
                  minimumSize: const Size(double.infinity, 80), // Buton boyutu
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
      decoration: InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(
          // Kenar için OutlineInputBorder kullanıyoruz
          borderRadius:
              BorderRadius.circular(10.0), // Kenarların yuvarlatılması
          borderSide: const BorderSide(
            color: Colors.blue, // Kenar rengi
            width: 2.0, // Kenar kalınlığı
          ),
        ),
        focusedBorder: OutlineInputBorder(
          // Alan aktif olduğunda kullanılacak kenar
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          // Hata durumu için kenar
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
      onChanged: (value) {
        name = value;
      },
      initialValue: name,
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.black, // Varsayılan arka plan rengi
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: backgroundColor,
          minimumSize: const Size(double.infinity, 80), // Buton boyutu
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
