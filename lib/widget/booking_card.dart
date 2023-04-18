import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import intl
import 'package:intl/intl.dart';
import 'package:project_tutorial/model/events.dart';
// import userdata
import 'package:project_tutorial/model/user.dart';
import 'package:project_tutorial/util/firestore.dart';

// import user info
import 'package:project_tutorial/util/user_info.dart';

// import snackbar
import 'package:project_tutorial/widget/snackbar_widget.dart';

class BookingCard extends StatelessWidget {
  EventsData event;
  final UserData user = LocalUserInfo.getLocalUser();
  final BuildContext context;
  final TextEditingController controller = TextEditingController();
  final VoidCallback updateUI;

  BookingCard({
    required this.context,
    required this.event,
    required this.updateUI,
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
    Icon doubleCheckIcon = Icon(
      Icons.check_circle,
      color: Colors.green,
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
    }
    // } else if (_status == 'Cancelled' && event.student_uid == user.uid) {
    //   _status = 'Student cancelled';
    //   //onCheck = () {};
    //   //showSnackBar(context, "Already cancelled. Ignore the button.");
    // } else if (_status == 'Cancelled' && event.tutor_uid == user.uid) {
    //   _status = 'Tutor cancelled';
    //   //onCheck = () {};
    //   //showSnackBar(context, "Already cancelled. Ignore the button.");
    // }

    // define the buttons
    List<Widget> buttons = <Widget>[
      ElevatedButton(
          onPressed: () async {
            await cancelBooking(event);
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: Colors.grey,
            padding: EdgeInsets.all(1),
          ),
          child: denyIcon),
      ElevatedButton(
          onPressed: () async {
            await acceptBooking(event);
          },
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: Colors.green[300],
            padding: EdgeInsets.all(1),
          ),
          child: checkIcon),
    ];
    // if status is submitted, and current user is student, only cancel event
    if (event.status == 'Submitted' && event.student_uid == user.uid) {
      buttons = <Widget>[
        ElevatedButton(
            onPressed: () async {
              await cancelBooking(event);
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.grey,
              padding: EdgeInsets.all(1),
            ),
            child: denyIcon),
      ];
    }
    // if status is upcoming, buttons are cancel and check in
    if (event.status == 'Upcoming') {
      buttons = <Widget>[
        ElevatedButton(
            onPressed: () async {
              await cancelBooking(event);
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.grey,
              padding: EdgeInsets.all(1),
            ),
            child: denyIcon),
        ElevatedButton(
            onPressed: () async {
              await checkIn(event);
            },
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Colors.green[300],
              padding: EdgeInsets.all(1),
            ),
            child: checkIcon),
      ];
    }
    // if status if finished or cancelled, buttons are empty
    if (event.status == "Finished" || event.status == "Cancelled") {
      buttons = <Widget>[
        ElevatedButton(
            onPressed: () async {
              await removeBooking(event);
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.grey,
              padding: EdgeInsets.all(1),
            ),
            child: denyIcon),
      ];
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
                      children: buttons,
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

  Future<void> removeBooking(EventsData event) async {
    String uid = event.uid ?? '';
    try {
      await FireStoreMethods().rmEvent(uid);
    } catch (e) {
      showSnackBar(context, "Serve Error. Please try again later");
    }
    updateUI();
  }

  Future<void> acceptBooking(EventsData event) async {
    String uid = event.uid ?? '';
    try {
      await FireStoreMethods().updateEvnetsByUid(uid, "Upcoming");
      event.status = 'Upcoming';
      setState() {
        event = event;
      }
    } catch (e) {
      showSnackBar(context, "Serve Error. Please try again later");
    }
    updateUI();
  }

  Future<void> cancelBooking(EventsData event) async {
    String? reason = await CancelDialog();
    if (reason == null) {
      return;
    }
    DateTime now = DateTime.now();
    // no penalty
    if (now.difference(event.start).inHours < 24) {
      showSnackBar(context, 'Testing phase. No penalty');
    }
    String uid = event.uid ?? '';
    try {
      //await FireStoreMethods().updateEvnetsByUid(uid, "Cancelled");
      await FireStoreMethods().rmEvent(uid);
      event.status = 'Cancelled';
      setState() {
        event = event;
      }
    } catch (e) {
      showSnackBar(context, "Serve Error. Please try again later");
    }
    updateUI();
  }

  Future<void> checkIn(EventsData event) async {
    // if more than 10 mins before the event, show a sncakbar about this
    DateTime now = DateTime.now();
    if (now.difference(event.start).inMinutes > 10) {
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
          event.status = 'Finished';
          setState() {
            event = event;
          }
        } catch (e) {
          showSnackBar(context, "Serve Error. Please try again later");
        }
      }
    }
    updateUI();
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
}
