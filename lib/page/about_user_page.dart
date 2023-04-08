import 'package:flutter/material.dart';
// model import
import 'package:project_tutorial/model/user.dart';
import 'package:project_tutorial/model/user_home_tmp.dart';
import 'package:project_tutorial/page/reserve_event_page.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';

//need: everything from user_home_tmp

class UserInfoPage extends StatelessWidget {
  UserInfoPage({super.key, required this.user});

  final User_home_tmp user;
  //final UserData localUser = LocalUserInfo.getLocalUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'About ${user.name}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade300,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Major: ${user.major}'),
                    Text('Year: ${user.year}'),
                    Text('Rating: ${user.rating}')
                  ],
                ),
                //Expanded(
                //child:
                Column(
                  children: [SizedBox(width: 20)],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Message: '),
                        IconButton(
                          icon: const Icon(Icons.message),
                          tooltip: 'message',
                          onPressed: () {}, //take to messaging page?
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Book: '),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'book',
                          onPressed: () {
                            Navigator.of(context).push(
                              // OR onPressed: () async { await Navigator.push(...);  await anyOtherMethod(); }
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ReserveEventPage(tutor_uid: user.uid);
                                },
                              ),
                            );
                          }, //take to booking page
                        ),
                      ],
                    ),
                  ],
                ),
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
