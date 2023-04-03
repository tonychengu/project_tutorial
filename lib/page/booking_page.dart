import 'package:flutter/material.dart';
import 'package:project_tutorial/model/events.dart';
import 'package:project_tutorial/page/upcoming_bookings_page.dart';
import 'package:project_tutorial/widget/button_widget.dart';
import 'package:project_tutorial/widget/textfield_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:project_tutorial/model/user.dart';

import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  State<BookingsPage> createState() => _BookingPageState();
}
// String validateRating(int value) {
//   if (!(value >= 0 && value <= 5)) {
//     return "Please enter an integr between 0 to 5";
//   }
//   return "";
// }

// String validateRating(int value) {
//   if (!(value >= 0 && value <= 5)) {
//     return "Please enter an integr between 0 to 5";
//   }
//   return "";
// }

class _BookingPageState extends State<BookingsPage> {
  int currentPage = 0;
  bool checkedValue = false;
  bool _validate = false;
  // void onTap(int index) {
  //   setState(() {
  //     currentPage = index;
  //   });
  // }

  late UserData user;
  List<UserData> submittedEventStudents = [];
  List<UserData> upcomingEventStudents = [];

  List<EventsData> submittedEvents = [];
  List<EventsData> upcomingEvents = [];

  void initState() {
    super.initState();

    user = LocalUserInfo.getLocalUser();
    _getEventReservation();
  }

  Future<void> _getEventReservation() async {
    List<UserData> tmp_submitted_stu = [];
    List<UserData> tmp_upcoming_stu = [];
    List<EventsData> tmp_submitted_events = [];
    List<EventsData> tmp_upcoming_events = [];
    final event = await FireStoreMethods().getEventsByUid(user.uid);
    for (final e in event) {
      if (e.status == "Submitted") {
        tmp_submitted_events.add(e);
        final student_query =
            await FireStoreMethods().getUserByUid(e.student_uid);
        final student = UserData.fromDocumentSnapshot(student_query.docs.first);
        tmp_submitted_stu.add(student);
      }
      if (e.status == "Upcoming") {
        tmp_upcoming_events.add(e);
        final student_query =
            await FireStoreMethods().getUserByUid(e.student_uid);
        final student = UserData.fromDocumentSnapshot(student_query.docs.first);
        tmp_upcoming_stu.add(student);
      }
    }
    setState(() {
      submittedEventStudents = tmp_submitted_stu;
      upcomingEventStudents = tmp_upcoming_stu;
      submittedEvents = tmp_submitted_events;
      upcomingEvents = tmp_upcoming_events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[300],
          centerTitle: true,
          toolbarHeight: 40,
          automaticallyImplyLeading: false,
          title: const Text('Review Your Past Session',
              style: TextStyle(fontSize: 20))),
      backgroundColor: Colors.green[200],
      body: Center(
        child: SizedBox(
          width: 390,
          height: 650,
          child: Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ListView(
                children: [
                  Text("Upcoming Bookings",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(height: 10),
                  Text(
                    'Review Your Tutor',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Review Swoop on Chemistry',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Jan 26th, 2023',
                    style: TextStyle(fontSize: 15, height: 2),
                  ),
                  const Text(
                    'Swoop Emory tutored you in CS170',
                    style: TextStyle(fontSize: 15, height: 1),
                  ),
                  const Text(
                    'Rate your session:',
                    style: TextStyle(fontSize: 20, height: 3),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.book,
                      color: Colors.green[500],
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  Text(
                    'Give your tutor feedback:',
                    style: TextStyle(fontSize: 20, height: 2),
                  ),
                  const TextField(
                    maxLines: 3,
                    maxLength: 100,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white30,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.white)),
                      hintText:
                          'Your comment will be anonymous, but please remember to be polite.',
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text('Work together again?',
                          style: TextStyle(fontSize: 20, height: 1)),
                      Checkbox(
                        value: checkedValue,
                        onChanged: (value) => setState(
                          () {
                            checkedValue = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) {
                              //   return CurrentBookingPage();
                              // })
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                          ),
                          child: const Text('Submit',
                              style: TextStyle(color: Colors.black, height: 1)),
                        ),
                      ]),
                  Column(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
