import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_tutorial/page/booking_page.dart';
import 'package:controller/controller.dart';

class upcoming_events_tmp {
  final String name;
  final String time;
  final String location;
  final String courses;
  final int Status;
  final String major;
  final String year;
  final bool isTutor;
  // 0 is upcoming, 1 is ongoing, 2 is finished, 3 is commented
  final String Comment;
  final String startTime;
  final String endTime;

  upcoming_events_tmp({
    required this.isTutor,
    required this.name,
    required this.time,
    required this.location,
    required this.courses,
    required this.Status,
    required this.Comment,
    required this.startTime,
    required this.endTime,
    required this.major,
    required this.year,
  });
}

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

  List<upcoming_events_tmp> _events = [
    upcoming_events_tmp(
        isTutor: true,
        name: 'Swoop',
        time: 'March 27th',
        location: 'Student center',
        courses: 'US History',
        Status: 0,
        Comment: '',
        major: 'Chemistry',
        year: 'Sophomore',
        startTime: '1:00PM',
        endTime: '2:00PM'),
    upcoming_events_tmp(
        isTutor: false,
        name: 'Dooley',
        time: 'March 31st',
        location: 'Woodruff Library',
        courses: 'Computer Science',
        Status: 0,
        Comment: '',
        major: 'Computer Science',
        year: 'Senior',
        startTime: '1:00PM',
        endTime: '2:00PM'),
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
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Text(
                                  '${event.name}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${event.major} | ${event.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Subject: ${event.courses}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 10),
                                Text(
                                  'Location: ${event.location}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Date: ${event.time}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 8),
                                Text(
                                    'Time: ${event.startTime} to ${event.endTime}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 10),
                                // Transform(
                                //   transform: Matrix4.identity()..scale(1.1),
                                //   child: Chip(
                                //     label: Text(
                                //       event.courses,
                                //     ),
                                //     backgroundColor: Colors.grey[200],
                                //   ),
                                // ),
                                // SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 21),
                              Text(
                                '${getType(event)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              CircleAvatar(
                                radius: 50,
                                //put image from backend
                                backgroundColor: event.isTutor
                                    ? Colors.blue.shade300
                                    : Colors.green.shade300,
                                foregroundColor: Colors.white,
                                child: Text(
                                  event.name.substring(0, 2),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          SizedBox(width: 25),
                        ],
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () async {
                                final reason = await CancelDialog();
                                if (reason == null || reason.isEmpty) return;
                                setState(() => this.Comment = reason);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.grey,
                                padding: EdgeInsets.all(1),
                              ),
                              child: const Icon(Icons.cancel)),
                          ElevatedButton(
                              onPressed: () {
                                CheckIN();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Colors.green[300],
                                padding: EdgeInsets.all(1),
                              ),
                              child: const Icon(Icons.fact_check_outlined)),
                          SizedBox(width: 15)
                        ],
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return const BookingsPage();
        })), //insert connection to comment bar
        child: Icon(Icons.comment),
      ),
    );
  }

  Future<String?> CancelDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('What is the reason you are canceling:'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(hintText: 'describe your reason'),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                },
              )
            ]),
      );
  Future CheckIN() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Enter Your Checkin code'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'enter the code'),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('CheckIn!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]),
      );
}

String getType(upcoming_events_tmp event) {
  if (event.isTutor) {
    return 'Tutor';
  } else {
    return 'Student';
  }
}
