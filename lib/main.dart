import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:project_tutorial/page/booking_page.dart';
import 'package:project_tutorial/page/search_page.dart';
import 'package:project_tutorial/page/home_page.dart';
import 'package:project_tutorial/page/profile_page.dart';

import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await UserInfo.init();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const PTutorial());
}

class PTutorial extends StatelessWidget {
  const PTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTutorial',
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List pages = [
    const HomePage(),
    const BookingsPage(),
    const SearchPage(),
    const ProfilePage(),
  ];
  void onTap(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: Container(
        color: Colors.blue.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 17),
          child: GNav(
            selectedIndex: currentPage,
            onTabChange: onTap,
            backgroundColor: Colors.blue.shade300,
            color: Colors.white,
            gap: 8,
            tabBackgroundColor: Colors.blue.shade100,
            padding: EdgeInsets.all(12),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.calendar_today,
                text: 'Bookings',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.people,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
