import 'package:flutter/material.dart';
// model import
import 'package:project_tutorial/model/user.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = LocalUserInfo.getLocalUser();
    final courses = user.getAvlCourses();
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 48),
          const SizedBox(
            height: 24,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 113, 190, 113)),
            ),
          ),
          const SizedBox(height: 24),
          buildName(context, user, courses),
          NumbersWidget(rating: user.getRating(), taught: user.getNumTaught()),
          const SizedBox(height: 24),
          const SizedBox(
            height: 24,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 113, 190, 113)),
            ),
          )
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
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
