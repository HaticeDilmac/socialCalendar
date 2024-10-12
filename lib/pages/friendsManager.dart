// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class FriendManagerScreen extends StatefulWidget {
//   @override
//   _FriendManagerScreenState createState() => _FriendManagerScreenState();
// }

// class _FriendManagerScreenState extends State<FriendManagerScreen> {
//   List<dynamic> friends = [];

//   void fetchFriends() async {
//     final response = await http.get(Uri.parse('http://localhost:5000/api/friends'));

//     if (response.statusCode == 200) {
//       setState(() {
//         friends = json.decode(response.body);
//       });
//     } else {
//       // Hata durumu
//     }
//   }

//   void addFriend(String name, DateTime birthday) async {
//     final response = await http.post(
//       Uri.parse('http://localhost:5000/api/friends'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
//     );

//     if (response.statusCode == 201) {
//       fetchFriends(); // Arkadaş eklendikten sonra güncelle
//     } else {
//       // Hata durumu
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchFriends();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sosyal İlişki Yönetimi'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               // Arkadaş eklemek için bir diyalog aç
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   String name = '';
//                   DateTime? birthday;
//                   return AlertDialog(
//                     title: const Text('Yeni Arkadaş Ekle'),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TextField(
//                           onChanged: (value) => name = value,
//                           decoration: const InputDecoration(labelText: 'İsim'),
//                         ),
//                         TextField(
//                           onTap: () async {
//                             birthday = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1900),
//                               lastDate: DateTime.now(),
//                             );
//                           },
//                           readOnly: true,
//                           decoration: const InputDecoration(labelText: 'Doğum Günü'),
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           if (birthday != null) {
//                             addFriend(name, birthday!);
//                             Navigator.of(context).pop();
//                           }
//                         },
//                         child: const Text('Ekle'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: friends.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(friends[index]['name']),
//             subtitle: Text(friends[index]['birthday'] != null ? 'Doğum Günü: ${friends[index]['birthday']}' : 'No Birthday'),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/friends.dart';
import 'addFriends.dart';

class FriendManagerScreen extends StatefulWidget {
  const FriendManagerScreen({super.key});

  @override
  State<FriendManagerScreen> createState() => _FriendManagerScreenState();
}

class _FriendManagerScreenState extends State<FriendManagerScreen> {
  List<Friend> friends = [];

  void getFriends() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/friends'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      //data convertor to Friends model
      List<Friend> fetchedFriends =
          data.map((json) => Friend.fromJson(json)).toList();
      //order brtday
      fetchedFriends.sort((a, b) => a.birthday.compareTo(b.birthday));

      setState(() {
        friends = fetchedFriends;
      });
    } else {
      if (kDebugMode) {
        print('hata');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  void addFriend(String name, DateTime birthday, List importantDates,
      List interactionLog) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/friends'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'birthday': birthday.toIso8601String(),
        'importantDates': importantDates,
        'interactionLog': interactionLog,
      }),
    );

    if (response.statusCode == 201) {
      getFriends(); //add friends then list refresh
    } else {
      // erorr stte
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sosyal İlişki Yönetimi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddFriendScreen(
                    onSave: (String name, DateTime birthday,
                        List importantDates, List interactionLog) {
                      addFriend(name, birthday, importantDates, interactionLog);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (BuildContext context, index) {
            final friend = friends[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: ListTile(
                title: Text(friend.name),
              ),
            );
          }),
    );
  }
}
