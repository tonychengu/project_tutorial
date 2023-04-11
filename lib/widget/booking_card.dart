import 'package:flutter/material.dart';
//import intl
import 'package:intl/intl.dart';
import 'package:project_tutorial/model/events.dart';
// import userdata
import 'package:project_tutorial/model/user.dart';

// import user info
import 'package:project_tutorial/util/user_info.dart';

// import snackbar
import 'package:project_tutorial/widget/snackbar_widget.dart';

class BookingCard extends StatelessWidget {
  EventsData event;
  final UserData user = LocalUserInfo.getLocalUser();
  VoidCallback onCheck;
  VoidCallback onDeny;

  BookingCard({
    required this.event,
    required this.onCheck,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    final start = DateFormat('M/d EEE h:mm a').format(event.start);
    final end = DateFormat('M/d EEE h:mm a').format(event.end);
    final time = '$start - $end';
    Icon checkIcon = Icon(
      Icons.check,
      color: Colors.green,
    );
    Icon denyIcon = Icon(
      Icons.close,
      color: Colors.red,
    );
    String _status = event.status;
    if (_status == 'Submitted' && event.student_uid == user.uid) {
      _status = 'Pending tutor confirmation';
    } else if (_status == 'Submitted' && event.tutor_uid == user.uid) {
      _status = 'Need confirmation';
    } else if (_status == 'Upcoming') {
      _status = 'Upcoming';
      checkIcon = Icon(
        Icons.fact_check_outlined,
        color: Colors.green,
      );
    } else if (_status == 'Cancelled' && event.student_uid == user.uid) {
      _status = 'Student cancelled';
      onCheck = () {};
      showSnackBar(context, "Already cancelled. Ignore the button.");
    } else if (_status == 'Cancelled' && event.tutor_uid == user.uid) {
      _status = 'Tutor cancelled';
      onCheck = () {};
      showSnackBar(context, "Already cancelled. Ignore the button.");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Row(
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
                      event.student_uid == user.uid
                          ? 'Tutor: ${event.tutor_name}'
                          : 'Student: ${event.student_name}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Location
                    Text(
                      'Location: ${event.location}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Status
                    Text(
                      'Status: ${_status}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Time
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Course
                    Transform(
                      transform: Matrix4.identity()..scale(1.1),
                      child: Chip(
                        label: Text(
                          event.course,
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 10),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              onDeny();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.all(1),
                            ),
                            child: denyIcon),
                        ElevatedButton(
                            onPressed: () {
                              onCheck();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.green[300],
                              padding: EdgeInsets.all(1),
                            ),
                            child: checkIcon),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
