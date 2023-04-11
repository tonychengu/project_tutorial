import 'package:flutter/material.dart';
// model import
import 'package:project_tutorial/model/user.dart';
import 'package:project_tutorial/model/user_home_tmp.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';

import 'package:project_tutorial/page/filters_page.dart';
import 'package:project_tutorial/page/about_user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showTutors = true;

  //static List<UserData> parseUsers()
  List<User_home_tmp> _tutors = [];
  List<User_home_tmp> _students = [];

  List<User_home_tmp> get _users => _showTutors ? _tutors : _students;

  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    final tutors = await FireStoreMethods().newTutors();
    final students = await FireStoreMethods().newStudents();
    List<UserData> tutorList = [];
    List<UserData> studentList = [];
    // iterate trought the query snapshot and parse the data
    tutors.docs.forEach((doc) {
      tutorList.add(UserData.fromDocumentSnapshot(doc));
    });
    students.docs.forEach((doc) {
      studentList.add(UserData.fromDocumentSnapshot(doc));
    });
    // turn the list of users into a list of User_home_tmp
    for (int i = 0; i < tutorList.length; i++) {
      _tutors.add(User_home_tmp(
        uid: tutorList[i].uid,
        name: tutorList[i].name,
        year: tutorList[i].year,
        major: tutorList[i].major,
        courses: tutorList[i].getAvlCourses(),
        rating: 1.0 * tutorList[i].ratings / tutorList[i].taughtCount,
        numSessions: tutorList[i].taughtCount,
      ));
    }
    for (int i = 0; i < studentList.length; i++) {
      _students.add(User_home_tmp(
        uid: studentList[i].uid,
        name: studentList[i].name,
        year: studentList[i].year,
        major: studentList[i].major,
        courses: studentList[i].getAvlCourses(),
        rating: 1.0 * studentList[i].ratings / studentList[i].taughtCount,
        numSessions: studentList[i].taughtCount,
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
        backgroundColor: Colors.green.shade300,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          //this decenters the header and i dont like that
          //const Text('Filters'),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
            // onPressed: () => Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (BuildContext context) {
            //   return const FiltersPage();
            // })),
            onPressed: () async {
              final newList = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FiltersPage(),
                ),
              );
              if (newList != null && newList.length != 0) {
                setState(() {
                  _tutors = newList;
                });
              }
            },
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
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoPage(user: user),
                    ),
                  );
                },
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
                              color: _showTutors ? Colors.red : Colors.red,
                              highlightColor:
                                  _showTutors ? Colors.red : Colors.red,
                            ),
                          ],
                        ),
                      ),
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
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.green[300],
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
          fillColor: Colors.green[300],
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

// legacy dummy data
  // List<User_home_tmp> _tutors = [
  //   User_home_tmp(
  //     name: 'Eva Williams',
  //     year: 'Junior',
  //     major: 'Computer Science',
  //     courses: ['Data Structures', 'Algorithms', 'Operating Systems'],
  //     rating: 4.8,
  //     numSessions: 12,
  //   ),
  //   User_home_tmp(
  //     name: 'John Doe',
  //     year: 'Freshman',
  //     major: 'Biology',
  //     courses: ['Intro to Biology', 'Genetics'],
  //     rating: 4.5,
  //     numSessions: 6,
  //   ),
  //   User_home_tmp(
  //     name: 'Sarah Smith',
  //     year: 'Senior',
  //     major: 'Chemistry',
  //     courses: ['Organic Chemistry', 'Physical Chemistry'],
  //     rating: 4.9,
  //     numSessions: 18,
  //   ),
  //   User_home_tmp(
  //     name: 'David Johnson',
  //     year: 'Sophomore',
  //     major: 'Mathematics',
  //     courses: ['Calculus', 'Linear Algebra', 'Number Theory'],
  //     rating: 4.2,
  //     numSessions: 3,
  //   ),
  //   User_home_tmp(
  //     name: 'Maggie Green',
  //     year: 'Junior',
  //     major: 'Environmental Science',
  //     courses: ['Climate Change', 'Sustainability'],
  //     rating: 4.7,
  //     numSessions: 9,
  //   ),
  //   User_home_tmp(
  //     name: 'Emma Jones',
  //     year: 'Freshman',
  //     major: 'History',
  //     courses: ['US History', 'World History'],
  //     rating: 4.0,
  //     numSessions: 1,
  //   ),
  // ];

  // List<User_home_tmp> _students = [
  //   User_home_tmp(
  //     name: 'Mark Davis',
  //     year: 'Junior',
  //     major: 'Mechanical Engineering',
  //     courses: ['Thermodynamics', 'Statics', 'Dynamics'],
  //     rating: 4.6,
  //     numSessions: 14,
  //   ),
  //   User_home_tmp(
  //     name: 'Alice Lee',
  //     year: 'Sophomore',
  //     major: 'Electrical Engineering',
  //     courses: ['Circuits', 'Digital Logic'],
  //     rating: 4.3,
  //     numSessions: 4,
  //   ),
  //   User_home_tmp(
  //     name: 'Chris Stuart',
  //     year: 'Senior',
  //     major: 'Physics',
  //     courses: ['Classical Mechanics', 'Electromagnetism', 'Quantum Mechanics'],
  //     rating: 4.8,
  //     numSessions: 20,
  //   ),
  //   User_home_tmp(
  //     name: 'Sophie Hernandez',
  //     year: 'Junior',
  //     major: 'English',
  //     courses: ['Creative Writing', 'British Literature'],
  //     rating: 4.5,
  //     numSessions: 8,
  //   ),
  //   User_home_tmp(
  //     name: 'William Taylor',
  //     year: 'Freshman',
  //     major: 'Political Science',
  //     courses: ['Introduction to Political Science', 'International Relations'],
  //     rating: 4.2,
  //     numSessions: 2,
  //   ),
  //   User_home_tmp(
  //     name: 'Olivia Johnson',
  //     year: 'Senior',
  //     major: 'Psychology',
  //     courses: ['Abnormal Psychology', 'Cognitive Psychology'],
  //     rating: 4.9,
  //     numSessions: 16,
  //   ),
  // ];