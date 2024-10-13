// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // class FriendManagerScreen extends StatefulWidget {
// //   @override
// //   _FriendManagerScreenState createState() => _FriendManagerScreenState();
// // }

// // class _FriendManagerScreenState extends State<FriendManagerScreen> {
// //   List<dynamic> friends = [];

// //   void fetchFriends() async {
// //     final response = await http.get(Uri.parse('http://localhost:5000/api/friends'));

// //     if (response.statusCode == 200) {
// //       setState(() {
// //         friends = json.decode(response.body);
// //       });
// //     } else {
// //       // Hata durumu
// //     }
// //   }

// //   void addFriend(String name, DateTime birthday) async {
// //     final response = await http.post(
// //       Uri.parse('http://localhost:5000/api/friends'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
// //     );

// //     if (response.statusCode == 201) {
// //       fetchFriends(); // Arkadaş eklendikten sonra güncelle
// //     } else {
// //       // Hata durumu
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchFriends();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Sosyal İlişki Yönetimi'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.add),
// //             onPressed: () {
// //               // Arkadaş eklemek için bir diyalog aç
// //               showDialog(
// //                 context: context,
// //                 builder: (context) {
// //                   String name = '';
// //                   DateTime? birthday;
// //                   return AlertDialog(
// //                     title: const Text('Yeni Arkadaş Ekle'),
// //                     content: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         TextField(
// //                           onChanged: (value) => name = value,
// //                           decoration: const InputDecoration(labelText: 'İsim'),
// //                         ),
// //                         TextField(
// //                           onTap: () async {
// //                             birthday = await showDatePicker(
// //                               context: context,
// //                               initialDate: DateTime.now(),
// //                               firstDate: DateTime(1900),
// //                               lastDate: DateTime.now(),
// //                             );
// //                           },
// //                           readOnly: true,
// //                           decoration: const InputDecoration(labelText: 'Doğum Günü'),
// //                         ),
// //                       ],
// //                     ),
// //                     actions: [
// //                       TextButton(
// //                         onPressed: () {
// //                           if (birthday != null) {
// //                             addFriend(name, birthday!);
// //                             Navigator.of(context).pop();
// //                           }
// //                         },
// //                         child: const Text('Ekle'),
// //                       ),
// //                     ],
// //                   );
// //                 },
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //       body: ListView.builder(
// //         itemCount: friends.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(friends[index]['name']),
// //             subtitle: Text(friends[index]['birthday'] != null ? 'Doğum Günü: ${friends[index]['birthday']}' : 'No Birthday'),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../model/friends.dart';
// import 'addFriends.dart';

// class FriendManagerScreen extends StatefulWidget {
//   const FriendManagerScreen({super.key});

//   @override
//   State<FriendManagerScreen> createState() => _FriendManagerScreenState();
// }

// class _FriendManagerScreenState extends State<FriendManagerScreen> {
//   List<Friend> friends = [];

//   void getFriends() async {
//     final response =
//         await http.get(Uri.parse('http://localhost:5000/api/friends'));
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);

//       // data convertor to Friends model
//       List<Friend> fetchedFriends =
//           data.map((json) => Friend.fromJson(json)).toList();

//       // Doğum günlerini sadece ay ve gün olarak sıralıyoruz
//       fetchedFriends.sort((a, b) {
//         // a ve b'nin doğum günlerini ay ve gün bazında karşılaştırıyoruz
//         int monthComparison = a.birthday.month.compareTo(b.birthday.month);
//         if (monthComparison != 0) {
//           return monthComparison;
//         } else {
//           return a.birthday.day.compareTo(b.birthday.day);
//         }
//       });

//       setState(() {
//         friends = fetchedFriends;
//       });
//     } else {
//       if (kDebugMode) {
//         print('Hata');
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getFriends();
//   }

//   void addFriend(String name, DateTime birthday, List importantDates,
//       List interactionLog) async {
//     final response = await http.post(
//       Uri.parse('http://localhost:5000/api/friends'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'name': name,
//         'birthday': birthday.toIso8601String(),
//         'importantDates': importantDates,
//         'interactionLog': interactionLog,
//       }),
//     );

//     if (response.statusCode == 201) {
//       getFriends(); // Ekleme sonrası listeyi yenile
//     } else {
//       // Hata durumu
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Social Calendar'),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => AddFriendScreen(
//                       onSave: (String name, DateTime birthday,
//                           List importantDates, List interactionLog) {
//                         addFriend(
//                             name, birthday, importantDates, interactionLog);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: ListView.builder(
//           itemCount: friends.length,
//           itemBuilder: (BuildContext context, index) {
//             final friend = friends[index];

//             DateTime currentDate = DateTime.now();

//             // Doğum günü geçmiş mi kontrolü (ay ve gün bazında)
//             bool hasBirthdayPassed =
//                 (friend.birthday.month < currentDate.month) ||
//                     (friend.birthday.month == currentDate.month &&
//                         friend.birthday.day < currentDate.day);

//             return Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       Text(friend.name),
//                       Text(friend.birthday.toString()),
//                       if(friend.importantDates[index].title.isNotEmpty)
//                       Text(friend.importantDates[index].title),

//                     ],
//                   ), // Arkadaşın adı
//                   if (hasBirthdayPassed) // Eğer doğum günü bu yıl içinde geçmişse resmi göster
//                     Image.asset(
//                       'assets/eye.png',
//                       height: 70,
//                     ),
//                 ],
//               ),
//             );
//           },
//         ));
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'addFriends.dart';
import '../model/friends.dart';
import 'package:flutter/material.dart';

class FriendListScreen extends StatefulWidget {
  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  List<Friend> friends = [];

 
  void getFriends() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/friends'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // data convertor to Friends model
      List<Friend> fetchedFriends =
          data.map((json) => Friend.fromJson(json)).toList();

      // Doğum günlerini sadece ay ve gün olarak sıralıyoruz
      fetchedFriends.sort((a, b) {
        // a ve b'nin doğum günlerini ay ve gün bazında karşılaştırıyoruz
        int monthComparison = a.birthday.month.compareTo(b.birthday.month);
        if (monthComparison != 0) {
          return monthComparison;
        } else {
          return a.birthday.day.compareTo(b.birthday.day);
        }
      });

      setState(() {
        friends = fetchedFriends;
      });
    } else {
      if (kDebugMode) {
        print('Hata');
      }
    }
  }

  void addFriend(String name, DateTime birthday) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/friends'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
    );

    if (response.statusCode == 201) {
      getFriends(); // Arkadaş eklendikten sonra güncelle
    } else {
      // Hata durumu
    }
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  void addOrUpdateFriend(Friend friend) {
    setState(() {
      // Check if the friend already exists in the list
      final existingFriendIndex = friends.indexWhere((f) => f.id == friend.id);
      if (existingFriendIndex != -1) {
        // Update the existing friend
        friends[existingFriendIndex] = friend;
      } else {
        // Add a new friend
        friends.add(friend);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arkadaşlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddFriendScreen(
                    onSave: (Friend newFriend) {
                      addOrUpdateFriend(newFriend);
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
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            title: Text(friend.name),
            subtitle: Text(
                'Doğum Günü: ${friend.birthday.toLocal().toString().split(' ')[0]}'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddFriendScreen(
                    onSave: (Friend updatedFriend) {
                      addOrUpdateFriend(updatedFriend);
                    },
                    existingFriend:
                        friend, // Pass the existing friend for editing
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
