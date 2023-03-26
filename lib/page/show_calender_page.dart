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

class ShowCalenderPage extends StatefulWidget {
  const ShowCalenderPage({super.key});

  @override
  State<ShowCalenderPage> createState() => _ShowCalenderPageState();
}

class _ShowCalenderPageState extends State<ShowCalenderPage> {
  late UserData user;
  late List<String> _timeslot;

  Future<void> initState() async {
    super.initState();

    user = LocalUserInfo.getLocalUser();
    _timeslot = await FireStoreMethods().getAllTimeSlots(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Availability'),
        ),
        body: Expanded(
          child: ListView.builder(
            itemCount: _timeslot.length,
            itemBuilder: (context, index) {
              return Text(_timeslot[index]);
            },
          ),
        ));
  }
}
