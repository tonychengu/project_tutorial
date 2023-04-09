import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// model import
import 'package:project_tutorial/model/user.dart';
import 'package:project_tutorial/model/user_home_tmp.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';
// widget import
import 'package:project_tutorial/widget/snackbar_widget.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  bool checkedValue = false;
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_courseController = TextEditingController();
  }

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.green[300],
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        title: const Text(
          'Filters',
          style: TextStyle(fontSize: 20),
        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Search: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 315,
                        child: TextField(
                          maxLines: 1,
                          controller: _courseController,
                          decoration: const InputDecoration(
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black)),
                            hintText: 'Search by course',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 315,
                        child: TextField(
                          maxLines: 1,
                          controller: _startController,
                          decoration: const InputDecoration(
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black)),
                            hintText: 'start time in yyyy/mm/dd hh:mm format',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Only show favorites: ',
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         color: Colors.grey.shade800,
                      //       ),
                      //     ),
                      //     Checkbox(
                      //       value: checkedValue,
                      //       onChanged: (value) => setState(
                      //         () {
                      //           checkedValue = value!;
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      ElevatedButton(
                        onPressed: () async {
                          final newTutors = await _getNewTutors();
                          Navigator.of(context).pop(newTutors);
                          //also save checkbox state
                        },
                        child: Text('Save changes'),
                      ),
                      //submit button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<User_home_tmp>> _getNewTutors() async {
    List<User_home_tmp> tutors = [];
    DateTime start = DateTime.now();
    if (_startController.text != '') {
      try {
        start = DateFormat("yyyy/MM/dd HH:mm").parse(_startController.text);
      } catch (e) {
        showSnackBar(context, "Invalid time format");
        return tutors;
      }
    }
    if (_courseController.text != '') {
      // search by course
      final snap = await FireStoreMethods()
          .getUsersBySearch(_courseController.text, start: start);
      return parseQuery(snap);
    } else {
      final snap = await FireStoreMethods().newTutors();
      showSnackBar(context, "You must enter a course to begin searching");
    }
    showSnackBar(context, "Server Error.");
    return tutors;
  }

  List<User_home_tmp> parseQuery(QuerySnapshot snapshot) {
    //final tutors = await FireStoreMethods().newTutors();
    List<UserData> tutorList = [];
    List<User_home_tmp> real_tutor_list = [];
    // iterate trought the query snapshot and parse the data
    snapshot.docs.forEach((doc) {
      tutorList.add(UserData.fromDocumentSnapshot(doc));
    });
    // turn the list of users into a list of User_home_tmp
    for (int i = 0; i < tutorList.length; i++) {
      real_tutor_list.add(User_home_tmp(
        uid: tutorList[i].uid,
        name: tutorList[i].name,
        year: tutorList[i].year,
        major: tutorList[i].major,
        courses: tutorList[i].getAvlCourses(),
        rating: 1.0 * tutorList[i].ratings / tutorList[i].taughtCount,
        numSessions: tutorList[i].taughtCount,
      ));
    }
    return real_tutor_list;
  }
}
