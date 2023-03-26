import 'dart:math';

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

  Future<void> updateUserAvailibity(String uid, List<DateTime> start,
      List<DateTime> end, List<bool> recurrent) async {
    try {
      WriteBatch batch = db.batch();
      // delete all documents with the same uid
      QuerySnapshot querySnapshot =
          await db.collection("timeslots").where("uid", isEqualTo: uid).get();
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });
      // add timeslots to a list
      List<List<dynamic>> slots = [];
      for (int i = 0; i < start.length; i++) {
        Timestamp _start = Timestamp.fromDate(start[i]);
        Timestamp _end = Timestamp.fromDate(end[i]);
        slots.add([_start, _end, recurrent[i]]);
      }
      // loop throught the list to see if there are overlapping timeslots
      for (int i = 0; i < slots.length; i++) {
        for (int j = i + 1; j < slots.length; j++) {
          // if there is a partial overlap, merge the two timeslots, if one of them is recurrent, the merged one is also recurrent
          if (slots[i][0].compareTo(slots[j][1]) < 0 &&
              slots[i][1].compareTo(slots[j][0]) > 0) {
            slots[i][0] = slots[i][0].compareTo(slots[j][0]) < 0
                ? slots[i][0]
                : slots[j][0];
            slots[i][1] = slots[i][1].compareTo(slots[j][1]) > 0
                ? slots[i][1]
                : slots[j][1];
            slots[i][2] = slots[i][2] || slots[j][2];
            slots.removeAt(j);
            j--;
          }
        }
      }
      // add new documents
      slots.forEach((slot) {
        // if the timeslot is recurrent, make it recurrent until nearest June or December
        if (slot[2]) {
          DateTime _start = slot[0].toDate();
          DateTime _end = slot[1].toDate();
          int add_month = min(6 - _start.month, 12 - _start.month);
          //Duration time_diff = _end.difference(_start);
          DateTime _finalEnd = DateTime(_end.year + 1, _end.month + add_month,
              _end.day, _end.hour, _end.minute);
          while (_start.isBefore(_finalEnd)) {
            _start = _start.add(Duration(days: 7));
            _end = _end.add(Duration(days: 7));
            batch.set(db.collection("timeslots").doc(), {
              "uid": uid,
              "start": Timestamp.fromDate(_start),
              "end": Timestamp.fromDate(_end),
            });
          }
        } else {
          batch.set(db.collection("timeslots").doc(), {
            "uid": uid,
            "start": Timestamp.fromDate(slot[0]),
            "end": Timestamp.fromDate(slot[1]),
          });
        }
      });
      batch.commit();
    } on FirebaseException catch (e) {
      rethrow;
    }
    return;
  }

  // to initialize the list of tutors at home page
  Future<QuerySnapshot> newTutors() async {
    QuerySnapshot querySnapshot = await db
        .collection("users")
        .where("availableCourses", isNotEqualTo: '')
        .limit(10)
        .get();
    return querySnapshot;
  }

  // to initialize the list of students at home page
  Future<QuerySnapshot> newStudents() async {
    QuerySnapshot querySnapshot = await db.collection("users").limit(10).get();
    return querySnapshot;
  }

  Future<QuerySnapshot> getUsersBySearch(String course,
      {DateTime? start, DateTime? end, double? ratings}) async {
    // query the tutors collection to get the uid of the tutors who teach the course
    // QuerySnapshot querySnapshot =
    //     await db.collection("tutors").where("course", isEqualTo: course).get();
    // query the users collection to get the user data of the tutors
    QuerySnapshot querySnapshot = await db
        .collection("users")
        .where("availableCourses", arrayContains: course)
        .get();
    //List<dynamic> uid = querySnapshot.docs.map((doc) => doc["uid"]).toList();
    // if there are time slots specified, query the timeslots collection to get the uid of the tutors who are available at the time
    if (start != null && end != null) {
      // if start of end is null, use default 30 minutes
      if (start == null) {
        // end time minus 30 mins
        start = end.subtract(Duration(minutes: 30));
      }
      if (end == null) {
        // start time plus 30 mins
        end = start.add(Duration(minutes: 30));
      }
      QuerySnapshot querySnapshot2 = await db
          .collection("timeslots")
          .where("start", isLessThanOrEqualTo: Timestamp.fromDate(end))
          .where("end", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .get();
      // remove the tutors who are not available at the time
      querySnapshot.docs.removeWhere((doc) => !querySnapshot2.docs
          .map((doc) => doc["uid"])
          .toList()
          .contains(doc["uid"]));
    }
    // query the users collection to get the user data of the tutors
    QuerySnapshot querySnapshot2 = await db
        .collection("users")
        .where("uid", whereIn: querySnapshot.docs.map((doc) => doc["uid"]))
        .get();
    // if there is a rating specified, filter the tutors by rating
    if (ratings != null) {
      querySnapshot2.docs.removeWhere(
          (doc) => 1.0 * doc["rating"] / doc["taughtCount"] < ratings);
    }
    return querySnapshot2;
  }

  // for homepage tutor search
  Future<List<List<DateTime>>> getTimeslotsByUid(List<String> uid) async {
    QuerySnapshot querySnapshot = await db
        .collection("timeslots")
        .where("uid", isEqualTo: uid)
        .orderBy("start")
        .get();
    // get all the events of the tutors
    QuerySnapshot querySnapshot2 = await db
        .collection("events")
        //where tutor_uid OR student_uid is in the list of uid
        .where("tutor_uid", whereIn: uid)
        .orderBy("start")
        .get();
    List<List<DateTime>> slots = populateSlots(querySnapshot);
    List<List<DateTime>> events = populateSlots(querySnapshot2);
    slots = parseTimeslots(slots, events);
    // get all the events of the tutors as a student
    querySnapshot2 = await db
        .collection("events")
        //where tutor_uid OR student_uid is in the list of uid
        .where("student_uid", whereIn: uid)
        .orderBy("start")
        .get();
    events = populateSlots(querySnapshot2);
    slots = parseTimeslots(slots, events);
    return slots;
  }

  List<List<DateTime>> populateSlots(QuerySnapshot querySnapshot) {
    List<List<DateTime>> slots = [];
    // populate slots with querySnapshot
    querySnapshot.docs.forEach((doc) {
      DateTime start = doc["start"].toDate();
      DateTime end = doc["end"].toDate();
      slots.add([start, end]);
    });
    return slots;
  }

  List<List<DateTime>> parseTimeslots(
      List<List<DateTime>> orig_slots, List<List<DateTime>> events) {
    // limit the events and orig_slots to next 7 days
    DateTime now = DateTime.now();
    DateTime nextWeek = now.add(Duration(days: 7));
    orig_slots.removeWhere(
        (slot) => slot[0].isBefore(now) || slot[0].isAfter(nextWeek));
    events.removeWhere(
        (event) => event[0].isBefore(now) || event[0].isAfter(nextWeek));
    // if the evenets if overlap with one of the orig_slots, split timeslots into before and after the event
    List<List<DateTime>> slots = [];
    orig_slots.forEach((slot) {
      DateTime start = slot[0];
      DateTime end = slot[1];
      bool overlap = false;
      events.forEach((event) {
        DateTime event_start = event[0];
        DateTime event_end = event[1];
        if (start.compareTo(event_end) < 0 && end.compareTo(event_start) > 0) {
          overlap = true;
          if (start.compareTo(event_start) < 0) {
            slots.add([start, event_start]);
          }
          if (end.compareTo(event_end) > 0) {
            slots.add([event_end, end]);
          }
        }
      });
      if (!overlap) {
        slots.add([start, end]);
      }
    });
    // remove the timeslots that are less than 30 minutes
    slots.removeWhere((slot) => slot[1].difference(slot[0]).inMinutes < 30);
    return slots;
  }

  Future<List<String>> getAllTimeSlots(String uid) async {
    QuerySnapshot querySnapshot = await db
        .collection("timeslots")
        .where("uid", isEqualTo: uid)
        .orderBy("start")
        .get();
    List<String> slots = [];
    querySnapshot.docs.forEach((doc) {
      DateTime start = doc["start"].toDate();
      DateTime end = doc["end"].toDate();
      slots.add(start.toString() + " - " + end.toString());
    });
    return slots;
  }
}
