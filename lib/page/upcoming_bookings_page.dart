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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<EventsData> _events = [
    // a dummy test data
    EventsData(
        course: 'CSC2001',
        student_name: '123',
        tutor_name: "tony",
        student_uid: "stu",
        tutor_uid: "tut",
        location: 'LT1',
        start: DateTime.now(),
        end: DateTime.now(),
        status: 'Submitted'),
  ];

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
          return BookingCard(event: event, onCheck: () {}, onDeny: () {});
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
