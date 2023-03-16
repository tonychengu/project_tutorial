import 'package:flutter/material.dart';
import 'package:project_tutorial/page/upcoming_bookings_page.dart';
import 'package:project_tutorial/widget/button_widget.dart';
import 'package:project_tutorial/widget/textfield_widget.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  State<BookingsPage> createState() => _BookingPageState();
}
// String validateRating(int value) {
//   if (!(value >= 0 && value <= 5)) {
//     return "Please enter an integr between 0 to 5";
//   }
//   return "";
// }

// String validateRating(int value) {
//   if (!(value >= 0 && value <= 5)) {
//     return "Please enter an integr between 0 to 5";
//   }
//   return "";
// }

class _BookingPageState extends State<BookingsPage> {
  int currentPage = 0;
  bool checkedValue = false;
  bool _validate = false;
  // void onTap(int index) {
  //   setState(() {
  //     currentPage = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Review Your Past Session',
              style: TextStyle(fontSize: 25))),
      body: Center(
        child: SizedBox(
          width: 390,
          height: 650,
          height: 650,
          child: Card(
            margin: EdgeInsets.all(15),
            elevation: 10,
            color: Colors.white38,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ListView(
                children: [
                  Text(
                    'Review Swoop on Chemistry',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Jan 26th, 2023',
                    style: TextStyle(fontSize: 15, height: 2),
                  ),
                  const Text(
                    'You tutored Swoop on Chemistry',
                    style: TextStyle(fontSize: 15, height: 1),
                  ),
                  const Text(
                    'rate your experience',
                    style: TextStyle(fontSize: 20, height: 3),
                  ),
                  const TextField(
                    maxLines: 1,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white30,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.white)),
                      //errorBorder: OutlineInputBorder(),
                      hintText:
                          'Enter a number from 1 to 5', //change to click out of 5 stars?
                      //errorText: validateRating(text),
                    ),
                  ),
                  Text(
                    'leave any comments',
                    style: TextStyle(fontSize: 20, height: 2),
                  ),
                  const TextField(
                    maxLines: 3,
                    maxLength: 100,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white30,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.white)),
                      hintText: 'How was it?',
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text('Tutor again?',
                          style: TextStyle(fontSize: 20, height: 1)),
                      Checkbox(
                        value: checkedValue,
                        onChanged: (value) => setState(
                          () {
                            checkedValue = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return CurrentBookingPage();
                          })),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          child: const Text('Submit',
                              style: TextStyle(color: Colors.black, height: 1)),
                        ),
                      ]),
                  Column(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
