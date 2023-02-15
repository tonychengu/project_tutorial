import 'package:flutter/material.dart';
import 'package:project_tutorial/page/home_page.dart';
import 'package:project_tutorial/page/profile_page.dart';
import 'package:project_tutorial/util/user_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserInfo.init();
  runApp(const PTutorial());
}

class PTutorial extends StatelessWidget {
  const PTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<Widget> pages = <Widget>[
    HomePage(),
    //BookingPAge(),
    //BalancePage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentPage],
        bottomNavigationBar: NavigationBar(
          //navigation bar at the bottom
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            // NavigationDestination(
            //     icon: Icon(Icons.calendar_month), label: 'Bookings'),
            // NavigationDestination(
            //     icon: Icon(Icons.money_off_csred), label: 'Balance'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
          // refresh the page
          onDestinationSelected: (int index) {
            setState(() {
              currentPage = index;
            });
          },
          selectedIndex: currentPage,
        ));
  }
}
