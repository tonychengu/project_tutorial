import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// model import
import 'package:project_tutorial/model/user.dart';
import 'package:project_tutorial/model/events.dart';
import 'package:project_tutorial/page/upcoming_bookings_page.dart';
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

  DateTime? _dateTime;
  final _dateTimeController = TextEditingController();

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
    return DateFormat('yyyy/MM/dd HH:mm').format(timeslot[0]) +
        ' - ' +
        DateFormat('yyyy/MM/dd HH:mm').format(timeslot[1]);
  }

  int currentIndex = 0;
  String _location = 'Zoom';
  String _startTime = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
  String duration = '60';

  Future<void> _showDateTimePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timePicked != null) {
        setState(() {
          _dateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );

          _dateTimeController.text =
              DateFormat('yyyy/MM/dd HH:mm').format(_dateTime!);

          _startTime = DateFormat('yyyy/MM/dd HH:mm').format(_dateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _availableCourses = _tutor.getAvlCourses();
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _timeslot.length,
                itemBuilder: (BuildContext context, int index) {
                  final timeslot = _timeslot[index];
                  final formattedTime = _formatTime(timeslot);
                  return Card(
                    child: ListTile(
                      title: Text(formattedTime),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select a course',
                border: OutlineInputBorder(),
                isDense: true,
                labelStyle: const TextStyle(color: Colors.green),
              ),
              value: _availableCourses[currentIndex],
              onChanged: (String? newValue) {
                setState(() {
                  currentIndex = _availableCourses.indexOf(newValue!);
                });
              },
              items: _availableCourses
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // a text input field for location
            TextField(
              decoration: InputDecoration(
                labelText: "Session Location",
                border: OutlineInputBorder(),
                isDense: true,
                labelStyle: const TextStyle(color: Colors.green),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (loc) => _location = loc,
            ),
            SizedBox(height: 10),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateTimeController,
              decoration: InputDecoration(
                labelText: "Select a session start time",
                hintText: "Tap to choose date and time",
                border: OutlineInputBorder(),
                isDense: true,
                labelStyle: const TextStyle(color: Colors.green),
              ),
              onTap: () {
                _showDateTimePicker();
              },
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Each session is one hour long.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (widget.tutor_uid == user.uid) {
                  showSnackBar(context, "You cannot reserve your own event");
                  return;
                }
                DateTime start = DateTime.now();
                try {
                  start = DateFormat("yyyy/MM/dd HH:mm").parse(_startTime);
                } catch (e) {
                  showSnackBar(context, "Invalid time format");
                  return;
                }
                int d = 60;
                final end = start.add(Duration(minutes: d));
                try {
                  // tuid, suid, start, end, course, location
                  EventsData e = EventsData(
                    tutor_uid: widget.tutor_uid,
                    student_uid: user.uid,
                    tutor_name: _tutor.name,
                    student_name: user.name,
                    status: "Submitted",
                    start: start,
                    end: end,
                    course: _availableCourses[currentIndex],
                    location: _location,
                  );
                  await FireStoreMethods().reserveEvent(e);
                  showSnackBar(context, "Event Reserved Successfully");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrentBookingPage(),
                    ),
                  );
                } catch (e) {
                  showSnackBar(
                      context, "Server Error: please try again later.");
                }
              },
              child: const Text("Reserve Event"),
            ),
          ],
        ),
      ),
    );
  }
}
