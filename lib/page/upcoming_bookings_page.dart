import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_tutorial/page/booking_page.dart';
import 'package:controller/controller.dart';

//import intl
import 'package:intl/intl.dart';
// import events.dart
import 'package:project_tutorial/model/events.dart';
// import booking card
import 'package:project_tutorial/widget/booking_card.dart';
// import snack bar
import 'package:project_tutorial/widget/snackbar_widget.dart';
// import firestore
import 'package:project_tutorial/util/firestore.dart';
// import user info
import 'package:project_tutorial/util/user_info.dart';
// import user
import 'package:project_tutorial/model/user.dart';

class CurrentBookingPage extends StatefulWidget {
  const CurrentBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  State<CurrentBookingPage> createState() => _CurrentBookingPageState();
}

class _CurrentBookingPageState extends State<CurrentBookingPage> {
  late TextEditingController controller;

  set Comment(String Comment) {
    this.Comment = Comment;
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    getEvents();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getEvents() async {
    UserData user = await LocalUserInfo.getLocalUser();
    List<EventsData> this_events =
        await FireStoreMethods().getEventsByUid(user.uid);
    setState(() {
      _events = this_events;
    });
  }

  // List<EventsData> _events = [
  //   // a dummy test data
  //   EventsData(
  //       course: 'CSC2001',
  //       student_name: '123',
  //       tutor_name: "tony",
  //       student_uid: "stu",
  //       tutor_uid: "tut",
  //       location: 'LT1',
  //       start: DateTime.now(),
  //       end: DateTime.now(),
  //       status: 'Submitted'),
  // ];
  List<EventsData> _events = [];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green.shade400,
          centerTitle: true,
          title:
              const Text('Upcoming Bookings', style: TextStyle(fontSize: 25))),
      body: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return BookingCard(
            context: context,
            event: event,
          );
          // return Padding(
          //   padding:
          //       const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.5),
          //           spreadRadius: 2,
          //           blurRadius: 5,
          //           offset: Offset(0, 3),
          //         ),
          //       ],
          //     ),
          //     child: Container(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(16.0),
          //           ),
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 SizedBox(height: 16),
          //                 Text(
          //                   event.name,
          //                   style: TextStyle(
          //                     fontSize: 25,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 SizedBox(height: 10),
          //                 Text(
          //                   'Location: ${event.location}',
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     color: Colors.grey.shade600,
          //                   ),
          //                 ),
          //                 SizedBox(height: 10),
          //                 Text(
          //                   'Status: ${event.location}',
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     color: Colors.grey.shade600,
          //                   ),
          //                 ),
          //                 SizedBox(height: 10),
          //                 Text(
          //                   event.time,
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     color: Colors.grey,
          //                   ),
          //                 ),
          //                 SizedBox(height: 10),
          //                 Transform(
          //                   transform: Matrix4.identity()..scale(1.1),
          //                   child: Chip(
          //                     label: Text(
          //                       event.courses,
          //                     ),
          //                     backgroundColor: Colors.grey[200],
          //                   ),
          //                 ),
          //                 SizedBox(height: 10),
          //                 ButtonBar(
          //                   alignment: MainAxisAlignment.end,
          //                   children: <Widget>[
          //                     ElevatedButton(
          //                         onPressed: () async {
          //                           final reason = await CancelDialog();
          //                           if (reason == null || reason.isEmpty)
          //                             return;
          //                           setState(() => this.Comment = reason);
          //                         },
          //                         style: ElevatedButton.styleFrom(
          //                           shape: CircleBorder(),
          //                           backgroundColor: Colors.grey,
          //                           padding: EdgeInsets.all(1),
          //                         ),
          //                         child: const Icon(Icons.cancel)),
          //                     ElevatedButton(
          //                         onPressed: () {
          //                           CheckIN();
          //                         },
          //                         style: ElevatedButton.styleFrom(
          //                           shape: StadiumBorder(),
          //                           backgroundColor: Colors.green[300],
          //                           padding: EdgeInsets.all(1),
          //                         ),
          //                         child: const Icon(Icons.fact_check_outlined)),
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return const BookingsPage();
        })), //insert connection to comment bar
        child: Icon(Icons.star),
      ),
    );
  }

  Future<void> acceptBooking(EventsData event) async {
    String uid = event.uid ?? '';
    try {
      await FireStoreMethods().updateEvnetsByUid(uid, "Upcoming");
    } catch (e) {
      showSnackBar(context, "Serve Error. Please try again later");
    }
  }

  Future<void> cancelBooking(EventsData event) async {
    DateTime now = DateTime.now();
    // no penalty
    if (now.difference(event.start).inHours < 24) {
      return;
    } else {
      // show a dialog to ask for reason
      String? reason = await CancelDialog();
      if (reason == null) {
        return;
      }
    }
    String uid = event.uid ?? '';
    try {
      await FireStoreMethods().updateEvnetsByUid(uid, "Cancelled");
    } catch (e) {
      showSnackBar(context, "Serve Error. Please try again later");
    }
  }

  Future<void> checkIn(EventsData event) async {
    // if more than 10 mins before the event, show a sncakbar about this
    DateTime now = DateTime.now();
    if (now.difference(event.start).inMinutes < 10) {
      showSnackBar(context, "You can only check in 10 mins before the event");
      return;
    }

    // get current user uid
    UserData user = await LocalUserInfo.getLocalUser();
    if (user.uid == event.tutor_uid) {
      // show a dialog and give the 6 digit code
      String code = event.code;
      await showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Please give the following code to the student: $code"),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                )
              ],
            ),
          ),
        ),
      );
      return;
    } else {
      // show a dialog and ask for the 6 digit code
      String code = event.code;
      String? input = await showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Please enter the code given by the tutor:"),
                TextField(
                  controller: controller,
                  autofocus: true,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: const Text("OK"),
                )
              ],
            ),
          ),
        ),
      );
      if (input != code) {
        showSnackBar(context, "Wrong code");
        return;
      } else {
        String uid = event.uid ?? '';
        try {
          await FireStoreMethods().updateEvnetsByUid(uid, "Finished");
          // give the tutor a dooley coin
          await FireStoreMethods().updateDooleyCoin(event.tutor_uid, 0);
          // remove the dooley coin from the student
          await FireStoreMethods().updateDooleyCoin(event.student_uid, 0);
          showSnackBar(context, "Testing phase. No coins transferred");
        } catch (e) {
          showSnackBar(context, "Serve Error. Please try again later");
        }
      }
    }
  }

  Future<String?> CancelDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('What is your reason for cancellation?'),
            content: TextField(
              maxLines: 3,
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                  hintText:
                      'Please remember, if you cancel within 24 hours of your session, you will still lose a Dooley Coin'),
            ),
            actions: [
              TextButton(
                child: Text('Nervermind!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Confirm Cancellation'),
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                },
              )
            ]),
      );
  Future CheckIN() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Enter Your Check-In Code code'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter your 6-digit code'),
              controller: controller,
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Start Session'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]),
      );
}
