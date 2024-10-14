// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';

// // // // class FriendManagerScreen extends StatefulWidget {
// // // //   @override
// // // //   _FriendManagerScreenState createState() => _FriendManagerScreenState();
// // // // }

// // // // class _FriendManagerScreenState extends State<FriendManagerScreen> {
// // // //   List<dynamic> friends = [];

// // // //   void fetchFriends() async {
// // // //     final response = await http.get(Uri.parse('http://localhost:5000/api/friends'));

// // // //     if (response.statusCode == 200) {
// // // //       setState(() {
// // // //         friends = json.decode(response.body);
// // // //       });
// // // //     } else {
// // // //       // Hata durumu
// // // //     }
// // // //   }

// // // //   void addFriend(String name, DateTime birthday) async {
// // // //     final response = await http.post(
// // // //       Uri.parse('http://localhost:5000/api/friends'),
// // // //       headers: {'Content-Type': 'application/json'},
// // // //       body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
// // // //     );

// // // //     if (response.statusCode == 201) {
// // // //       fetchFriends(); // Arkadaş eklendikten sonra güncelle
// // // //     } else {
// // // //       // Hata durumu
// // // //     }
// // // //   }

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     fetchFriends();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text('Sosyal İlişki Yönetimi'),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: const Icon(Icons.add),
// // // //             onPressed: () {
// // // //               // Arkadaş eklemek için bir diyalog aç
// // // //               showDialog(
// // // //                 context: context,
// // // //                 builder: (context) {
// // // //                   String name = '';
// // // //                   DateTime? birthday;
// // // //                   return AlertDialog(
// // // //                     title: const Text('Yeni Arkadaş Ekle'),
// // // //                     content: Column(
// // // //                       mainAxisSize: MainAxisSize.min,
// // // //                       children: [
// // // //                         TextField(
// // // //                           onChanged: (value) => name = value,
// // // //                           decoration: const InputDecoration(labelText: 'İsim'),
// // // //                         ),
// // // //                         TextField(
// // // //                           onTap: () async {
// // // //                             birthday = await showDatePicker(
// // // //                               context: context,
// // // //                               initialDate: DateTime.now(),
// // // //                               firstDate: DateTime(1900),
// // // //                               lastDate: DateTime.now(),
// // // //                             );
// // // //                           },
// // // //                           readOnly: true,
// // // //                           decoration: const InputDecoration(labelText: 'Doğum Günü'),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                     actions: [
// // // //                       TextButton(
// // // //                         onPressed: () {
// // // //                           if (birthday != null) {
// // // //                             addFriend(name, birthday!);
// // // //                             Navigator.of(context).pop();
// // // //                           }
// // // //                         },
// // // //                         child: const Text('Ekle'),
// // // //                       ),
// // // //                     ],
// // // //                   );
// // // //                 },
// // // //               );
// // // //             },
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: ListView.builder(
// // // //         itemCount: friends.length,
// // // //         itemBuilder: (context, index) {
// // // //           return ListTile(
// // // //             title: Text(friends[index]['name']),
// // // //             subtitle: Text(friends[index]['birthday'] != null ? 'Doğum Günü: ${friends[index]['birthday']}' : 'No Birthday'),
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'dart:convert';
// // // import 'package:flutter/foundation.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;

// // // import '../model/friends.dart';
// // // import 'addFriends.dart';

// // // class FriendManagerScreen extends StatefulWidget {
// // //   const FriendManagerScreen({super.key});

// // //   @override
// // //   State<FriendManagerScreen> createState() => _FriendManagerScreenState();
// // // }

// // // class _FriendManagerScreenState extends State<FriendManagerScreen> {
// // //   List<Friend> friends = [];

// // //   void getFriends() async {
// // //     final response =
// // //         await http.get(Uri.parse('http://localhost:5000/api/friends'));
// // //     if (response.statusCode == 200) {
// // //       List<dynamic> data = json.decode(response.body);

// // //       // data convertor to Friends model
// // //       List<Friend> fetchedFriends =
// // //           data.map((json) => Friend.fromJson(json)).toList();

// // //       // Doğum günlerini sadece ay ve gün olarak sıralıyoruz
// // //       fetchedFriends.sort((a, b) {
// // //         // a ve b'nin doğum günlerini ay ve gün bazında karşılaştırıyoruz
// // //         int monthComparison = a.birthday.month.compareTo(b.birthday.month);
// // //         if (monthComparison != 0) {
// // //           return monthComparison;
// // //         } else {
// // //           return a.birthday.day.compareTo(b.birthday.day);
// // //         }
// // //       });

// // //       setState(() {
// // //         friends = fetchedFriends;
// // //       });
// // //     } else {
// // //       if (kDebugMode) {
// // //         print('Hata');
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     getFriends();
// // //   }

// // //   void addFriend(String name, DateTime birthday, List importantDates,
// // //       List interactionLog) async {
// // //     final response = await http.post(
// // //       Uri.parse('http://localhost:5000/api/friends'),
// // //       headers: {'Content-Type': 'application/json'},
// // //       body: json.encode({
// // //         'name': name,
// // //         'birthday': birthday.toIso8601String(),
// // //         'importantDates': importantDates,
// // //         'interactionLog': interactionLog,
// // //       }),
// // //     );

// // //     if (response.statusCode == 201) {
// // //       getFriends(); // Ekleme sonrası listeyi yenile
// // //     } else {
// // //       // Hata durumu
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //         appBar: AppBar(
// // //           title: const Text('Social Calendar'),
// // //           actions: [
// // //             IconButton(
// // //               icon: const Icon(Icons.add),
// // //               onPressed: () {
// // //                 Navigator.of(context).push(
// // //                   MaterialPageRoute(
// // //                     builder: (context) => AddFriendScreen(
// // //                       onSave: (String name, DateTime birthday,
// // //                           List importantDates, List interactionLog) {
// // //                         addFriend(
// // //                             name, birthday, importantDates, interactionLog);
// // //                       },
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //         body: ListView.builder(
// // //           itemCount: friends.length,
// // //           itemBuilder: (BuildContext context, index) {
// // //             final friend = friends[index];

// // //             DateTime currentDate = DateTime.now();

// // //             // Doğum günü geçmiş mi kontrolü (ay ve gün bazında)
// // //             bool hasBirthdayPassed =
// // //                 (friend.birthday.month < currentDate.month) ||
// // //                     (friend.birthday.month == currentDate.month &&
// // //                         friend.birthday.day < currentDate.day);

// // //             return Container(
// // //               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
// // //               margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
// // //               decoration: BoxDecoration(
// // //                 borderRadius: BorderRadius.circular(10),
// // //                 border: Border.all(color: Colors.black),
// // //               ),
// // //               child: Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Column(
// // //                     children: [
// // //                       Text(friend.name),
// // //                       Text(friend.birthday.toString()),
// // //                       if(friend.importantDates[index].title.isNotEmpty)
// // //                       Text(friend.importantDates[index].title),

// // //                     ],
// // //                   ), // Arkadaşın adı
// // //                   if (hasBirthdayPassed) // Eğer doğum günü bu yıl içinde geçmişse resmi göster
// // //                     Image.asset(
// // //                       'assets/eye.png',
// // //                       height: 70,
// // //                     ),
// // //                 ],
// // //               ),
// // //             );
// // //           },
// // //         ));
// // //   }
// // // }

// // import 'dart:convert';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // import 'addFriends.dart';
// // import '../model/friends.dart';

// // class FriendListScreen extends StatefulWidget {
// //   const FriendListScreen({super.key});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _FriendListScreenState createState() => _FriendListScreenState();
// // }

// // class _FriendListScreenState extends State<FriendListScreen> {
// //   List<Friend> friends = [];

// //   void getFriends() async {
// //     final response =
// //         await http.get(Uri.parse('http://localhost:5000/api/friends'));
// //     if (response.statusCode == 200) {
// //       List<dynamic> data = json.decode(response.body);

// //       // data convertor to Friends model
// //       List<Friend> fetchedFriends =
// //           data.map((json) => Friend.fromJson(json)).toList();

// //       // birthday order just month and day
// //       fetchedFriends.sort((a, b) {
// //         int monthComparison = a.birthday.month.compareTo(b.birthday.month);
// //         if (monthComparison != 0) {
// //           return monthComparison;
// //         } else {
// //           return a.birthday.day.compareTo(b.birthday.day);
// //         }
// //       });

// //       setState(() {
// //         friends = fetchedFriends;
// //       });
// //     } else {
// //       if (kDebugMode) {
// //         print('Hata');
// //       }
// //     }
// //   }

// //   void addFriend(String name, DateTime birthday) async {
// //     final response = await http.post(
// //       Uri.parse('http://localhost:5000/api/friends'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
// //     );

// //     if (response.statusCode == 201) {
// //       getFriends(); // Friends page refresh
// //     } else {
// //       // erorr state
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     getFriends();
// //   }

// //   void addOrUpdateFriend(Friend friend) {
// //     setState(() {
// //       // Check if the friend already exists in the list
// //       final existingFriendIndex = friends.indexWhere((f) => f.id == friend.id);
// //       if (existingFriendIndex != -1) {
// //         // Update the existing friend
// //         friends[existingFriendIndex] = friend;
// //       } else {
// //         // Add a new friend
// //         friends.add(friend);
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color.fromARGB(255, 231, 226, 226),
// //       // appBar: AppBar(
// //       //   title: const Text('Arkadaşlar'),
// //       //   actions: [
// //       //     IconButton(
// //       //       icon: const Icon(Icons.add),
// //       //       onPressed: () {
// //       //         Navigator.of(context).push(
// //       //           MaterialPageRoute(
// //       //             builder: (context) => AddFriendScreen(
// //       //               onSave: (Friend newFriend) {
// //       //                 addOrUpdateFriend(newFriend);
// //       //               },
// //       //             ),
// //       //           ),
// //       //         );
// //       //       },
// //       //     ),
// //       //   ],
// //       // ),
// //       body: ListView.builder(
// //         itemCount: friends.length,
// //         itemBuilder: (context, index) {
// //           final friend = friends[index];
// //           return Container(
// //             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
// //             margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
// //             decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(25), color: Colors.white),
// //             child: ListTile(
// //               title: Text(friend.name),
// //               subtitle: Text(
// //                   'Doğum Günü: ${friend.birthday.toLocal().toString().split(' ')[0]}'),
// //               onTap: () {
// //                 Navigator.of(context).push(
// //                   MaterialPageRoute(
// //                     builder: (context) => AddFriendScreen(
// //                       onSave: (Friend updatedFriend) {
// //                         addOrUpdateFriend(updatedFriend);
// //                       },
// //                       existingFriend:
// //                           friend, // Pass the existing friend for editing
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
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
// import 'package:intl/intl.dart';

// import 'addFriends.dart';
// import '../model/friends.dart';

// class FriendListScreen extends StatefulWidget {
//   const FriendListScreen({super.key});

//   @override
//   _FriendListScreenState createState() => _FriendListScreenState();
// }

// class _FriendListScreenState extends State<FriendListScreen> {
//   List<Friend> friends = [];
//   int _currentIndex = 0;

//   void getFriends() async {
//     final response =
//         await http.get(Uri.parse('http://localhost:5000/api/friends'));
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);

//       // Data convertor to Friends model
//       List<Friend> fetchedFriends =
//           data.map((json) => Friend.fromJson(json)).toList();

//       // Birthday order just month and day
//       fetchedFriends.sort((a, b) {
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
//         print('Error');
//       }
//     }
//   }

//   void addFriend(String name, DateTime birthday) async {
//     final response = await http.post(
//       Uri.parse('http://localhost:5000/api/friends'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'name': name, 'birthday': birthday.toIso8601String()}),
//     );

//     if (response.statusCode == 201) {
//       getFriends(); // Refresh friends list
//     } else {
//       // Handle error
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getFriends();
//   }

//   void addOrUpdateFriend(Friend friend) {
//     setState(() {
//       // Check if the friend already exists in the list
//       final existingFriendIndex = friends.indexWhere((f) => f.id == friend.id);
//       if (existingFriendIndex != -1) {
//         // Update the existing friend
//         friends[existingFriendIndex] = friend;
//       } else {
//         // Add a new friend
//         friends.add(friend);
//       }
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     DateTime currentDate = DateTime.now();
//     var outputFormat = DateFormat('d MMMM yyyy', 'tr_TR');
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 231, 226, 226),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//               child: Text(
//                 'Social Calendar',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 25),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 outputFormat.format(currentDate),
//                 style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14),
//               ),
//             ),
//             _currentIndex == 0
//                 ? _listViewBuilderMethod(currentDate, outputFormat)
//                 : const Center(
//                     child: Text("Social Calendar"),
//                   ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () => _onItemTapped(0),
//                 child: const Text(
//                   'Friends List',
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black, // Buton arkaplanı siyah
//                   minimumSize: const Size(130, 60), // Buton boyutu
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => AddFriendScreen(
//                         onSave: (Friend newFriend) {
//                           addOrUpdateFriend(newFriend);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   '+',
//                   style: TextStyle(fontSize: 30, color: Colors.white),
//                 ),
//               ), // Boşluk bırakmak için
//               TextButton(
//                 onPressed: () => _onItemTapped(1),
//                 child: const Text(
//                   'Social Calendar',
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Expanded _listViewBuilderMethod(
//       DateTime currentDate, DateFormat outputFormat) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: friends.length,
//         itemBuilder: (context, index) {
//           final friend = friends[index];

//           bool hasBirthDay = (friend.birthday.month < currentDate.month) ||
//               (friend.birthday.month == currentDate.month &&
//                   friend.birthday.day < currentDate.day);

//           var formattedDate = outputFormat.format(friend.birthday);
//           return Container(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//             margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25), color: Colors.white),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                           color: hasBirthDay ? Colors.red : Colors.green,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: const Icon(Icons.grade),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           friend.name,
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               letterSpacing: 0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: [
//                             Text('$formattedDate\t-\t',
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 13,
//                                   letterSpacing: 0,
//                                 )),
//                             Text(
//                                 (hasBirthDay == true)
//                                     ? 'BirthDay completed'
//                                     : 'BirthDay not completed',
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 12,
//                                   letterSpacing: 0,
//                                 )),
//                           ],
//                         )
//                       ],
//                     ),
//                     const Spacer(),
//                     const Icon(Icons.today)
//                   ],
//                 ),

//                 // Important Dates List
//                 const SizedBox(height: 10),
//                 Text(
//                   'Important Dates:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black.withOpacity(0.7),
//                   ),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: friend.importantDates.length,
//                   itemBuilder: (context, index) {
//                     final importantDate = friend.importantDates[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 5.0),
//                       child: Text(
//                         '- ${importantDate.title}: ${outputFormat.format(importantDate.date)}',
//                         style:
//                             const TextStyle(fontSize: 13, color: Colors.black),
//                       ),
//                     );
//                   },
//                 ),

//                 // Interaction Log List
//                 const SizedBox(height: 10),
//                 Text(
//                   'Interaction Log:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black.withOpacity(0.7),
//                   ),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: friend.interactionLog.length,
//                   itemBuilder: (context, index) {
//                     final interaction = friend.interactionLog[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 5.0),
//                       child: Text(
//                         '- ${interaction.type}: ${outputFormat.format(interaction.date)}',
//                         style:
//                             const TextStyle(fontSize: 13, color: Colors.black),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'addFriends.dart';
import '../model/friends.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  List<Friend> friends = [];
  int _currentIndex = 0;
  Map<int, bool> isExpandedMap =
      {}; // Her arkadaş için açılıp kapanan durumu tutan harita

  void getFriends() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/friends'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Data convertor to Friends model
      List<Friend> fetchedFriends =
          data.map((json) => Friend.fromJson(json)).toList();

      // Birthday order just month and day
      fetchedFriends.sort((a, b) {
        int monthComparison = a.birthday.month.compareTo(b.birthday.month);
        if (monthComparison != 0) {
          return monthComparison;
        } else {
          return a.birthday.day.compareTo(b.birthday.day);
        }
      });

      setState(() {
        friends = fetchedFriends;
        // Tüm arkadaşlar için başlangıçta isExpandedMap'i false yapıyoruz
        for (int i = 0; i < friends.length; i++) {
          isExpandedMap[i] = false;
        }
      });
    } else {
      if (kDebugMode) {
        print('Error');
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
      getFriends(); // Refresh friends list
    } else {
      // Handle error
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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void deleteFriend(int index) {
    setState(() {
      friends.removeAt(index);
    });
  }

  void editFriend(Friend friend) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddFriendScreen(
          onSave: (updatedFriend) {
            addOrUpdateFriend(updatedFriend);
          },
          existingFriend: friend,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    var outputFormat = DateFormat('d MMMM yyyy', 'tr_TR');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 226, 226),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                'Social Calendar',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                outputFormat.format(currentDate),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            _currentIndex == 0
                ? _listViewBuilderMethod(currentDate, outputFormat)
                : const Center(
                    child: Text("Social Calendar"),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () => _onItemTapped(0),
                child: const Text(
                  'Friends List',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Buton arkaplanı siyah
                  minimumSize: const Size(130, 60), // Buton boyutu
                ),
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
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ), // Boşluk bırakmak için
              TextButton(
                onPressed: () => _onItemTapped(1),
                child: const Text(
                  'Social Calendar',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _listViewBuilderMethod(
      DateTime currentDate, DateFormat outputFormat) {
    return Expanded(
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          bool isExpanded = isExpandedMap[index] ??
              false; // Her bir arkadaş için genişletme durumu
          bool hasBirthDay = (friend.birthday.month < currentDate.month) ||
              (friend.birthday.month == currentDate.month &&
                  friend.birthday.day < currentDate.day);

          var formattedDate = outputFormat.format(friend.birthday);
          return Dismissible(
            key: Key(friend.id.toString()),
            background: _editBackground(), // Sola sürükleme arka planı
            secondaryBackground:
                _deleteBackground(), // Sağa sürükleme arka planı
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return await _showDeleteConfirmationDialog(context);
              } else if (direction == DismissDirection.startToEnd) {
                return Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddFriendScreen(
                      onSave: (updatedFriend) {
                        addOrUpdateFriend(updatedFriend);
                      },
                      existingFriend: friend, // Arkadaş bilgisini gönderiyoruz
                    ),
                  ),
                );
              }
            },
            onDismissed: (direction) {
              deleteFriend(index);
            },
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpandedMap[index] = !isExpandedMap[
                      index]!; // Tıklanınca genişletme durumunu değiştir
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TitleWidget(
                        hasBirthDay: hasBirthDay,
                        friend: friend,
                        formattedDate: formattedDate),
                    // Eğer isExpanded true ise, önemli tarihler ve etkileşim günlüğünü gösteriyoruz
                    if (isExpanded) ...[
                      // Important Dates List
                      const SizedBox(height: 10),
                      Text(
                        'Important Dates:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      for (var date in friend.importantDates)
                        Text(
                          '${date.title} - ${outputFormat.format(date.date)}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black),
                        ),
                      const SizedBox(height: 10),
                      // Interaction Log List
                      Text(
                        'Interaction Log:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: friend.interactionLog.length,
                        itemBuilder: (context, index) {
                          final logEntry = friend.interactionLog[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '${logEntry.type} on ${outputFormat.format(logEntry.date)}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black),
                            ),
                          );
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Sola sürükleme sırasında gösterilecek düzenleme ikonu arka planı
  Widget _editBackground() {
    return Container(
      color: Colors.black,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hayır'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  Widget _deleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.hasBirthDay,
    required this.friend,
    required this.formattedDate,
  });

  final bool hasBirthDay;
  final Friend friend;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          //Icon Container widget
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: hasBirthDay ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.grade),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friend.name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('$formattedDate\t-\t',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      letterSpacing: 0,
                    )),
                Text(
                    (hasBirthDay == true)
                        ? 'BirthDay completed'
                        : 'BirthDay not completed',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      letterSpacing: 0,
                    )),
              ],
            )
          ],
        ),
        const Spacer(),
        const Icon(Icons.today)
      ],
    );
  }
}
