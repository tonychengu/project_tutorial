import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
//snackbar
import 'package:project_tutorial/widget/snackbar_widget.dart';
// chat page
import 'package:project_tutorial/page/chat_page.dart';

//need: everything from user_home_tmp

class UserInfoPage extends StatefulWidget {
  User_home_tmp user;
  UserInfoPage({super.key, required this.user});
  UserData localUser = LocalUserInfo.getLocalUser();

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
//class UserInfoPage extends StatelessWidget {
  //UserInfoPage({super.key, required this.user});

  //final UserData localUser = LocalUserInfo.getLocalUser();
  String imagePath =
      "https://firebasestorage.googleapis.com/v0/b/cs370-329f4.appspot.com/o/profileImg.png?alt=media";

  void initState() {
    super.initState();
    _getUserImage();
  }

  _getUserImage() async {
    QuerySnapshot queryData =
        await FireStoreMethods().getUserByUid(widget.user.uid);
    final json = queryData.docs.first.data() as Map<String, dynamic>;
    String url = json['imagePath'];
    if (url != null) {
      setState(() {
        imagePath = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'About ${widget.user.name}',
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
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 48),
                // ProfileWidget(
                //   imagePath: imagePath,
                //   onClicked: () async {},
                // ),
                buildImage(imagePath),
                const SizedBox(height: 10),
                buildName(context, widget.user),
                const SizedBox(height: 10),
                NumbersWidget(
                    rating: widget.user.rating.toStringAsFixed(2),
                    taught: widget.user.numSessions
                        .toString()), // build ratings and courses taught
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('    Message: '),
                          IconButton(
                            icon: const Icon(Icons.message),
                            tooltip: 'message',
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ChatPage(
                                    id: widget.user.uid,
                                    name: widget.user.name,
                                  );
                                },
                              ));
                            }, //take to messaging page?
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('    Book: '),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            tooltip: 'book',
                            onPressed: () {
                              showSnackBar(
                                  context, "Testing phase. No charge occurs.");
                              if (widget.localUser.balance < 1) {
                                showSnackBar(context,
                                    "Insufficient Balance. Testing phase so you can still book.");
                                //return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReserveEventPage(
                                          tutor_uid: widget.user.uid,
                                        )),
                              );
                            }, //take to booking page
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

Widget buildName(BuildContext context, User_home_tmp user) => Column(
      children: [
        IntrinsicHeight(
          // Row of  Name | Year
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const VerticalDivider(width: 36, thickness: 1),
              Text(
                user.year,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Row of Major | Minor
        Text(
          'Major: ${user.major}',
          //: 'Major: ${user.major} / Minor: ${user.minor}',
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),
        // Row of Available Courses
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            "Available Courses",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: user.courses.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 75,
                  height: 50,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(user.courses[index]),
                  ),
                );
              }),
        )
      ],
    );

Widget buildImage(imagePath) {
  // final image = imagePath != null
  //     ? NetworkImage(imagePath!)
  //     : Image.asset('assets/profile.png') as ImageProvider;
  final image = NetworkImage(imagePath);
  return Center(
    child: ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image as ImageProvider,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    ),
  );
}
