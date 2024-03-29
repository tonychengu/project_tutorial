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
  UserData user = LocalUserInfo.getLocalUser();
  List<String> _timeslot = ['No timeslot found.'];

  void initState() {
    super.initState();

    //user = LocalUserInfo.getLocalUser();
    _getTimeslot();
  }

  Future<void> _getTimeslot() async {
    //user = LocalUserInfo.getLocalUser();
    _timeslot = await FireStoreMethods().getAllTimeSlots(user.uid);
    setState(() {
      _timeslot = _timeslot;
      if (_timeslot.length == 0) _timeslot.add('No timeslot found.');
    });
  }

  @override
  void dipose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_timeslot = FireStoreMethods().getAllTimeSlots(user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Availability'),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _timeslot.length,
        itemBuilder: (context, index) {
          return Text(_timeslot[index]);
        },
      ),
    );
  }
}
