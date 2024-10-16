
import 'package:flutter/material.dart';

import '../model/friends.dart';

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