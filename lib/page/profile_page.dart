// reference https://github.com/JohannesMilke/user_profile_ii_example/blob/master/lib/widget/profile_widget.dart

import 'package:flutter/material.dart';
import 'package:project_tutorial/util/firestore.dart';
import 'package:provider/provider.dart';
// model import
import 'package:project_tutorial/model/user.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firebase_auth.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';
// page import
import 'package:project_tutorial/page/edit_profile_page.dart';
import 'package:project_tutorial/page/login_page.dart';
import 'package:project_tutorial/page/edit_calender_page.dart';
import 'package:project_tutorial/page/show_calender_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = LocalUserInfo.getLocalUser();
    final courses = user.getAvlCourses();
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 48),
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditProfilePage(),
              ));
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          buildName(context, user, courses),
          const SizedBox(height: 10),
          NumbersWidget(
              rating: user.getRating(),
              taught: user.getNumTaught()), // build ratings and courses taught
          const SizedBox(height: 10),
          buildAbout(user),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditCalenderPage(),
              ));
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 24),
              primary: Theme.of(context).accentColor,
              onPrimary: Colors.white,
            ),
            icon: Icon(Icons.edit),
            label: Text("Edit Calendar"),
          ),
          SizedBox(height: 0),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShowCalenderPage(),
              ));
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 24),
              primary: Theme.of(context).accentColor,
              onPrimary: Colors.white,
            ),
            icon: Icon(Icons.calendar_today),
            label: Text("Show Calendar"),
          ),
          SizedBox(height: 10),
          TextButton.icon(
            onPressed: () async {
              LocalUserInfo.clearUser();
              await context.read<FirebaseAuthMethods>().signOut(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: Icon(Icons.logout),
            label: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

Widget buildName(BuildContext context, UserData user, List<String> courses) =>
    Column(
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
          //user.minor == null
          //    ? 'Major: ${user.major}'
          //    : 'Major: ${user.major} / Minor: ${user.minor}',
          'Major: ${user.major}',
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.attach_money,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Balance: ${user.balance}',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Row of Available Courses
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            "Available Courses",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
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
                    child: Text(courses[index]),
                  ),
                );
              }),
        )
      ],
    );

Widget buildAbout(UserData user) => Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.about ??
                "This user has not written anything about themselves yet.",
            style: TextStyle(fontSize: 10, height: 1.4),
          ),
        ],
      ),
    );
