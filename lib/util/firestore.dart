import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_tutorial/widget/snackbar_widget.dart';

// two databases: one uid as primary key and save user data, the other use uid and course taught as primary to get all the tutors
// final userdata = {
//   'uid': 123,
//   'name': 'John',
//   'email': '123@123.com',
//   'year': 'Senior',
//   'major': 'Computer Science',
//   'minor': 'Math',
//   'availableCourses': 'CS101,CS102,CS103,CS104,CS105',
//   'about': 'I am a senior computer science student',
//   'taughtCount': 0,
//   'ratings': 0,
// }

class FireStoreMethods {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addUserData(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      await db.collection("users").doc(data['uid']).set(data);
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
      rethrow;
    }
    try {
      await modifyTutorAndCourses(context, data);
    } on FirebaseException catch (e) {
      rethrow;
    }
    return;
  }

  Future<void> updateUserData(
      BuildContext context, Map<String, dynamic> data) async {
    final uid = data["uid"];
    try {
      await db.collection("users").doc(uid).set(data);
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
      rethrow;
    }
    try {
      await modifyTutorAndCourses(context, data);
    } on FirebaseException catch (e) {
      rethrow;
    }
    return;
  }

  Future<void> modifyTutorAndCourses(
      BuildContext context, Map<String, dynamic> data) async {
    final courses = data["availableCourses"].split(',');
    final uid = data["uid"];
    try {
      WriteBatch batch = db.batch();
      // delete all documents with the same uid
      QuerySnapshot querySnapshot =
          await db.collection("tutors").where("uid", isEqualTo: uid).get();
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });
      // add new documents
      courses.forEach((course) {
        batch.set(db.collection("tutors").doc(), {
          "uid": uid,
          "course": course,
        });
      });
      batch.commit();
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
      rethrow;
    }
    return;
  }

  Future<QuerySnapshot> getTutorsByCourse(String course) async {
    QuerySnapshot querySnapshot =
        await db.collection("tutors").where("course", isEqualTo: course).get();
    return querySnapshot;
  }

  Future<QuerySnapshot> getUserByUid(String uid) async {
    QuerySnapshot querySnapshot =
        await db.collection("users").where("uid", isEqualTo: uid).get();
    return querySnapshot;
  }

  Future<void> updateUserAvailibity(
      String uid, List<DateTime> start, List<DateTime> end) async {
    try {
      WriteBatch batch = db.batch();
      // delete all documents with the same uid
      QuerySnapshot querySnapshot =
          await db.collection("timeslots").where("uid", isEqualTo: uid).get();
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });
      // add timeslots to a list
      List<List<Timestamp>> slots = [];
      for (int i = 0; i < start.length; i++) {
        Timestamp _start = Timestamp.fromDate(start[i]);
        Timestamp _end = Timestamp.fromDate(end[i]);
        slots.add([_start, _end]);
      }
      // loop throught the list to see if there are overlapping timeslots
      for (int i = 0; i < slots.length; i++) {
        for (int j = i + 1; j < slots.length; j++) {
          // if there is a partial overlap, merge the two timeslots
          if (slots[i][0].compareTo(slots[j][1]) < 0 &&
              slots[i][1].compareTo(slots[j][0]) > 0) {
            slots[i][0] = slots[i][0].compareTo(slots[j][0]) < 0
                ? slots[i][0]
                : slots[j][0];
            slots[i][1] = slots[i][1].compareTo(slots[j][1]) > 0
                ? slots[i][1]
                : slots[j][1];
            slots.removeAt(j);
            j--;
          }
        }
      }
      // add new documents
      slots.forEach((slot) {
        batch.set(db.collection("timeslots").doc(), {
          "uid": uid,
          "start": slot[0],
          "end": slot[1],
        });
      });
      batch.commit();
    } on FirebaseException catch (e) {
      rethrow;
    }
    return;
  }
}
