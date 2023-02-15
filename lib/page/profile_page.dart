// reference https://github.com/JohannesMilke/user_profile_ii_example/blob/master/lib/widget/profile_widget.dart

import 'package:flutter/material.dart';
// model import
import 'package:project_tutorial/model/user.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';
// page import
import 'package:project_tutorial/page/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserInfo.getUser();
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
          const SizedBox(height: 24),
          buildName(context, user, courses),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }
}

Widget buildName(BuildContext context, User user, List<String> courses) =>
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
        const SizedBox(height: 24),
        // Row of Major | Minor
        Text(
          user.minor == null
              ? 'Major: ${user.major}'
              : 'Major: ${user.major} / Minor: ${user.minor}',
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 24),
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
          height: 75,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 75,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
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

Widget buildAbout(User user) => Container(
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
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
