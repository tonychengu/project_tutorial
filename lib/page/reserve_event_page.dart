import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// model import
import 'package:project_tutorial/model/user.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';
import 'package:project_tutorial/widget/textfield_widget.dart';
import 'package:project_tutorial/widget/snackbar_widget.dart';

class ReserveEventPage extends StatefulWidget {
  final String tutor_uid;

  const ReserveEventPage({Key? key, required this.tutor_uid}) : super(key: key);

  @override
  State<ReserveEventPage> createState() => _ReserveEventPageState();
}

class _ReserveEventPageState extends State<ReserveEventPage> {
  UserData user = LocalUserInfo.getLocalUser();
  List<List<DateTime>> _timeslot = [];
  UserData _tutor = LocalUserInfo.getLocalUser();

  void initState() {
    super.initState();

    //user = LocalUserInfo.getLocalUser();
    _getTimeslot();
    _getTutorData();
  }

  Future<void> _getTimeslot() async {
    //user = LocalUserInfo.getLocalUser();
    _timeslot = await FireStoreMethods().getTimeslotsByUid(widget.tutor_uid);
    setState(() {
      _timeslot = _timeslot;
    });
  }

  Future<void> _getTutorData() async {
    final queryData = await FireStoreMethods().getUserByUid(widget.tutor_uid);
    setState(() {
      _tutor = UserData.fromJson(
          queryData.docs.first.data() as Map<String, dynamic>);
    });
  }

  @override
  void dipose() {
    super.dispose();
  }

  String _formatTime(List<DateTime> timeslot) {
    return DateFormat('yyyy/MM/dd hh:mm').format(timeslot[0]) +
        ' - ' +
        DateFormat('yyyy/MM/dd hh:mm').format(timeslot[1]);
  }

  int currentIndex = 0;
  String _location = 'Zoom';
  String _startTime = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
  String duration = '60';
  @override
  Widget build(BuildContext context) {
    List<String> _availableCourses = _tutor.getAvlCourses();
    return Scaffold(
        appBar: AppBar(
          title: Text('Reserve Event'),
        ),
        body: Column(
          children: [
            Text("Tutor's following week availability is"),
            SizedBox(height: 10),
            // List of timeslots
            Expanded(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _timeslot.length,
              itemBuilder: (context, index) {
                return Text(_formatTime(_timeslot[index]));
              },
            )),
            SizedBox(height: 10),
            Text("You want to be tutored in"),
            SizedBox(height: 10),
            // a dropdown menu of available courses
            DropdownButton<String>(
              value: _availableCourses[currentIndex],
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  currentIndex = _availableCourses.indexOf(newValue!);
                });
              },
              items: _availableCourses
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            // a text input field for location
            TextFieldWidget(
                label: "Session Location",
                text: _location,
                onChanged: (loc) => _location = loc),
            SizedBox(height: 10),
            // Start and End time of the event
            TextFieldWidget(
                label: "Session Start Time (in yyyy/mm/dd hh:mm format)",
                text: _startTime,
                onChanged: (t) {
                  if (t.length == 16) {
                    _startTime = t;
                  }
                }),
            SizedBox(height: 10),
            TextFieldWidget(
                label: "Session Duration (in minutes)",
                text: duration.toString(),
                onChanged: (d) {
                  duration = d;
                }),
            SizedBox(height: 10),
            // a button to reserve the event
            ElevatedButton(
                onPressed: () async {
                  DateTime start = DateTime.now();
                  try {
                    start = DateFormat("yyyy/MM/dd HH:mm").parse(_startTime);
                  } catch (e) {
                    showSnackBar(context, "Invalid time format");
                    return;
                  }
                  int d = 60;
                  final end = start.add(Duration(minutes: d));
                  // if (widget.tutor_uid == user.uid) {
                  //   showSnackBar(context, "You cannot reserve your own event");
                  //   return;
                  // }
                  try {
                    // tuid, suid, start, end, course, location
                    await FireStoreMethods().reserveEvent(
                        widget.tutor_uid,
                        user.uid,
                        start,
                        end,
                        _availableCourses[currentIndex],
                        _location);
                  } catch (e) {
                    showSnackBar(context, "Server Error: resubmit the event.");
                  }
                  showSnackBar(context, "Event Reserved Successfully");
                },
                child: Text("Reserve Event")),
          ],
        ));
  }
}
