import 'package:flutter/material.dart';
// model import
import 'package:project_tutorial/model/user.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';

//need: everything from user_home_tmp

class User_home_tmp {
  final String uid;
  final String name;
  final String year;
  final String major;
  final List<String> courses;
  final double rating;
  final int numSessions;

  const User_home_tmp({
    required this.uid,
    required this.name,
    required this.year,
    required this.major,
    required this.courses,
    required this.rating,
    required this.numSessions,
  });
}

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key, required this.user});

  final User_home_tmp user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'About ${user.name}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade300,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Major: ${user.major}'),
                    Text('Year: ${user.year}'),
                    Text('Rating: ${user.rating}')
                  ],
                ),
                //Expanded(
                //child:
                Column(
                  children: [SizedBox(width: 20)],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Message: '),
                        IconButton(
                          icon: const Icon(Icons.message),
                          tooltip: 'message',
                          onPressed: () {}, //take to messaging page?
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Book: '),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'book',
                          onPressed: () {}, //take to booking page
                        ),
                      ],
                    ),
                  ],
                ),
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
