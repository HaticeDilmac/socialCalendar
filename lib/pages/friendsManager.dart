import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FriendManagerScreen extends StatefulWidget {
  @override
  _FriendManagerScreenState createState() => _FriendManagerScreenState();
}

class _FriendManagerScreenState extends State<FriendManagerScreen> {
  List<dynamic> friends = [];

  void fetchFriends() async {
    final response = await http.get(Uri.parse('http://localhost:5000/api/friends'));

    if (response.statusCode == 200) {
      setState(() {
        friends = json.decode(response.body);
      });
    } else {
      // Hata durumu
    }
  }

  void addFriend(String name, DateTime birthday) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/friends'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
    );

    if (response.statusCode == 201) {
      fetchFriends(); // Arkadaş eklendikten sonra güncelle
    } else {
      // Hata durumu
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sosyal İlişki Yönetimi'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Arkadaş eklemek için bir diyalog aç
              showDialog(
                context: context,
                builder: (context) {
                  String name = '';
                  DateTime? birthday;
                  return AlertDialog(
                    title: Text('Yeni Arkadaş Ekle'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) => name = value,
                          decoration: InputDecoration(labelText: 'İsim'),
                        ),
                        TextField(
                          onTap: () async {
                            birthday = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                          },
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Doğum Günü'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (birthday != null) {
                            addFriend(name, birthday!);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Ekle'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(friends[index]['name']),
            subtitle: Text(friends[index]['birthday'] != null ? 'Doğum Günü: ${friends[index]['birthday']}' : 'No Birthday'),
          );
        },
      ),
    );
  }
}
