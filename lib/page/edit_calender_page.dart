import 'package:flutter/material.dart';
import 'package:project_tutorial/model/user.dart';
import 'package:project_tutorial/util/user_info.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:intl/intl.dart';
// util
import 'package:project_tutorial/util/firestore.dart';
// widget
import 'package:project_tutorial/widget/snackbar_widget.dart';

class EditCalenderPage extends StatefulWidget {
  @override
  _EditCalenderPageState createState() => _EditCalenderPageState();
}

class _EditCalenderPageState extends State<EditCalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // list of start datetime
  List<DateTime> _start = [];
  // list of end datetime
  List<DateTime> _end = [];
  List<String> _timeslot = [];
  List<bool> _recurrent = [];
  bool checkbox_value = false;
  late UserData user;

  void initState() {
    super.initState();

    user = LocalUserInfo.getLocalUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Availability'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              _updateAvailability(context);
            },
            //onPressed: _updateAvailability,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ), //SizedBox
              Text(
                'Make recurrent for semester: ',
                style: TextStyle(fontSize: 17.0),
              ), //Text
              SizedBox(width: 10), //SizedBox
              /** Checkbox Widget **/
              Checkbox(
                value: checkbox_value,
                onChanged: (bool? value) {
                  setState(() {
                    checkbox_value = value!;
                  });
                },
              ), //Checkbox
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _selectTimeRange(context),
            child: Text("Add time slots"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _timeslot.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_timeslot[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _timeslot.removeAt(index);
                        _start.removeAt(index);
                        _end.removeAt(index);
                        _recurrent.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
        // A list builder show all time slots
      ),
    );
  }

  Future<void> _selectTimeRange(BuildContext context) async {
    final TimeRange? result = await showTimeRangePicker(
      context: context,
      start: TimeOfDay(hour: 0, minute: 0),
      end: TimeOfDay(hour: 23, minute: 59),
    );

    if (result != null) {
      setState(() {
        // append start and end time to list
        if (_selectedDay == null) {
          _selectedDay = DateTime.now();
        }
        // if the timeslot is less then 30 mintues, show snackbar
        if (result.endTime.hour * 60 +
                result.endTime.minute -
                (result.startTime.hour * 60 + result.startTime.minute) <
            30) {
          showSnackBar(context, 'Time slot must be at least 30 minutes');
          return;
        }
        final startDateTime = DateTime(_selectedDay!.year, _selectedDay!.month,
            _selectedDay!.day, result.startTime.hour, result.startTime.minute);
        final endDateTime = DateTime(_selectedDay!.year, _selectedDay!.month,
            _selectedDay!.day, result.endTime.hour, result.endTime.minute);
        _start.add(startDateTime);
        _end.add(endDateTime);
        _recurrent.add(checkbox_value);
        final start = DateFormat('M/d EEE h:mm a').format(startDateTime);
        final end = DateFormat('M/d EEE h:mm a').format(endDateTime);
        if (checkbox_value) {
          _timeslot.add('$start - $end (Recurrent)');
        } else {
          _timeslot.add('$start - $end');
        }
      });
    }
  }

  Future<void> _updateAvailability(context) async {
    try {
      final uid = user.uid;
      await FireStoreMethods()
          .updateUserAvailibity(uid, _start, _end, _recurrent);
    } catch (e) {
      print(e);
    }
  }
}
