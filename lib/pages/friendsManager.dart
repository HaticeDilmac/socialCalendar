import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'addFriends.dart';
import '../model/friends.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
                : _calendarBuilderMethod(),
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
                      builder: (context) => const AddFriendScreen(),
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
                return await _showDeleteConfirmationDialog(context, friend.id);
              } else if (direction == DismissDirection.startToEnd) {
                return Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddFriendScreen(
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

  Widget _calendarBuilderMethod() {
    return Container(
      height: 400,
      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        ),
        dataSource: MeetingDataSource(getBirthdayAppointments()),
        onTap: (CalendarTapDetails details) {
          // İsterseniz takvim tıklamaları için burada işlem yapabilirsiniz.
        },
      ),
    );
  }

  List<Appointment> getBirthdayAppointments() {
    List<Appointment> appointments = [];
    for (var friend in friends) {
      appointments.add(Appointment(
        startTime: DateTime(
          DateTime.now().year,
          friend.birthday.month,
          friend.birthday.day,
        ),
        endTime: DateTime(
          DateTime.now().year,
          friend.birthday.month,
          friend.birthday.day,
        ).add(const Duration(hours: 1)),
        subject: friend.name,
        color: Colors.black,
        isAllDay: true,
      ));
    }
    return appointments;
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

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, String id) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => {deleteFriends(context, id)},
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void deleteFriends(BuildContext dialogContext, String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5000/api/friends/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 204) {
      // delete state successful
      Navigator.of(dialogContext).pop(); // Alert'i kapat
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const FriendListScreen()),
      );
    } else {
      Navigator.of(dialogContext).pop();
      // erorr state send erorr message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete friend.')),
      );
    }
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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
