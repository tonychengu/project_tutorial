import 'package:flutter/material.dart';
// model import
import 'package:project_tutorial/model/user.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';

class User_home_tmp {
  final String name;
  final String year;
  final String major;
  final List<String> courses;
  final double rating;
  final int numSessions;

  User_home_tmp({
    required this.name,
    required this.year,
    required this.major,
    required this.courses,
    required this.rating,
    required this.numSessions,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showTutors = true;

  List<User_home_tmp> _tutors = [
    User_home_tmp(
      name: 'Eva Williams',
      year: 'Junior',
      major: 'Computer Science',
      courses: ['Data Structures', 'Algorithms', 'Operating Systems'],
      rating: 4.8,
      numSessions: 12,
    ),
    User_home_tmp(
      name: 'John Doe',
      year: 'Freshman',
      major: 'Biology',
      courses: ['Intro to Biology', 'Genetics'],
      rating: 4.5,
      numSessions: 6,
    ),
    User_home_tmp(
      name: 'Sarah Smith',
      year: 'Senior',
      major: 'Chemistry',
      courses: ['Organic Chemistry', 'Physical Chemistry'],
      rating: 4.9,
      numSessions: 18,
    ),
    User_home_tmp(
      name: 'David Johnson',
      year: 'Sophomore',
      major: 'Mathematics',
      courses: ['Calculus', 'Linear Algebra', 'Number Theory'],
      rating: 4.2,
      numSessions: 3,
    ),
    User_home_tmp(
      name: 'Maggie Green',
      year: 'Junior',
      major: 'Environmental Science',
      courses: ['Climate Change', 'Sustainability'],
      rating: 4.7,
      numSessions: 9,
    ),
    User_home_tmp(
      name: 'Emma Jones',
      year: 'Freshman',
      major: 'History',
      courses: ['US History', 'World History'],
      rating: 4.0,
      numSessions: 1,
    ),
  ];

  List<User_home_tmp> _students = [
    User_home_tmp(
      name: 'Mark Davis',
      year: 'Junior',
      major: 'Mechanical Engineering',
      courses: ['Thermodynamics', 'Statics', 'Dynamics'],
      rating: 4.6,
      numSessions: 14,
    ),
    User_home_tmp(
      name: 'Alice Lee',
      year: 'Sophomore',
      major: 'Electrical Engineering',
      courses: ['Circuits', 'Digital Logic'],
      rating: 4.3,
      numSessions: 4,
    ),
    User_home_tmp(
      name: 'Chris Stuart',
      year: 'Senior',
      major: 'Physics',
      courses: ['Classical Mechanics', 'Electromagnetism', 'Quantum Mechanics'],
      rating: 4.8,
      numSessions: 20,
    ),
    User_home_tmp(
      name: 'Sophie Hernandez',
      year: 'Junior',
      major: 'English',
      courses: ['Creative Writing', 'British Literature'],
      rating: 4.5,
      numSessions: 8,
    ),
    User_home_tmp(
      name: 'William Taylor',
      year: 'Freshman',
      major: 'Political Science',
      courses: ['Introduction to Political Science', 'International Relations'],
      rating: 4.2,
      numSessions: 2,
    ),
    User_home_tmp(
      name: 'Olivia Johnson',
      year: 'Senior',
      major: 'Psychology',
      courses: ['Abnormal Psychology', 'Cognitive Psychology'],
      rating: 4.9,
      numSessions: 16,
    ),
  ];

  List<User_home_tmp> get _users => _showTutors ? _tutors : _students;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showTutors ? 'Tutors' : 'Students',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          //this decenters the header and i dont like that
          //const Text('Filters'),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: _showTutors
                                  ? Colors.blueAccent
                                  : Colors.blueAccent,
                              child: Text(user.name.substring(0, 2)),
                            ),
                            const SizedBox(height: 16),
                            IconButton(
                              icon: const Icon(Icons.favorite),
                              tooltip: 'Favorite',
                              onPressed: () {}, //add to user favorites list
                              color: _showTutors
                                  ? Colors.blueAccent
                                  : Colors.blueAccent,
                              highlightColor:
                                  _showTutors ? Colors.red : Colors.red,
                            ),
                          ],
                        )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${user.major} | ${user.year}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 30,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: user.courses.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return Chip(
                                  label: Text(user.courses[index]),
                                  backgroundColor: Colors.grey[200],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: 8),
                              Text(
                                '${user.rating} (${user.numSessions} sessions)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ToggleButtons(
          onPressed: (int index) {
            setState(() {
              _showTutors = index == 0;
            });
          },
          isSelected: [_showTutors, !_showTutors],
          selectedColor: Colors.white,
          fillColor: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Tutors'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Students'),
            ),
          ],
          color: Colors.grey, // set the unselected button color
        ),
      ),
    );
  }
}
