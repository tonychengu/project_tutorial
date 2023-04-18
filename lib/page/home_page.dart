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
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              user.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${user.major} | ${user.year}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 36,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: user.courses.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  return Chip(
                                    label: Text(
                                      user.courses[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.star, size: 20, color: Colors.amber),
                                SizedBox(width: 8),
                                Text(
                                  '${user.rating.toStringAsFixed(1)} (${user.numSessions} sessions)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}
