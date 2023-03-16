import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_tutorial/page/booking_page.dart';

class CurrentBookingPage extends StatelessWidget {
  CurrentBookingPage({Key? key}) : super(key: key);

  @override
  bool val = true;
  // if (val){
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (BuildContext context) {
  //     return BookingsPage();
  //     })
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Upcoming Bookings',
                style: TextStyle(fontSize: 25))),
        body: Center(
          child: ListView(
            children: [
              Container(
                width: 390,
                height: 400,
                child: Card(
                  margin: EdgeInsets.all(15),
                  elevation: 10,
                  color: Color(0xB2AED9F9),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(children: [
                      Text(
                        'Swoop the Eagle',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Feb 30th, 2023',
                        style: TextStyle(fontSize: 15, height: 2),
                      ),
                      Text(
                        'Subject: ',
                        style: TextStyle(fontSize: 20, height: 3),
                      ),
                    ]),
                  ),
                ),
              ),
              Container(
                width: 390,
                height: 400,
                child: Card(
                  margin: EdgeInsets.all(15),
                  elevation: 10,
                  color: Color(0xB2AED9F9),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(children: [
                      Text(
                        'Emory A',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Feb 30th, 2023',
                        style: TextStyle(fontSize: 15, height: 2),
                      ),
                      Text(
                        'Subject: ',
                        style: TextStyle(fontSize: 20, height: 3),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const BookingsPage();
          })), //insert connection to comment bar
          child: Icon(Icons.comment),
        ));
  }
}
