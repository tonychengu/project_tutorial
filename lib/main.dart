import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:project_tutorial/page/booking_page.dart';
import 'package:project_tutorial/page/search_page.dart';
import 'package:project_tutorial/page/home_page.dart';
import 'package:project_tutorial/page/profile_page.dart';
import 'package:project_tutorial/page/login_page.dart';

// util
import 'package:project_tutorial/util/firestore.dart';
import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:project_tutorial/util/user_info.dart';

import 'package:project_tutorial/firebase_options.dart';

//widget
import 'package:project_tutorial/widget/snackbar_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalUserInfo.init();
  runApp(const PTutorial());
}

class PTutorial extends StatelessWidget {
  const PTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        Provider<FireStoreMethods>(create: (_) => FireStoreMethods()),
      ],
      child: MaterialApp(
        title: 'PTutorial',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
      ),
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
        color: Colors.green.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 17),
          child: GNav(
            selectedIndex: currentPage,
            onTabChange: onTap,
            backgroundColor: Colors.green.shade300,
            color: Colors.white,
            gap: 8,
            tabBackgroundColor: Colors.green.shade100,
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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const RootPage();
    } else if (firebaseUser != null && firebaseUser.emailVerified) {
      showSnackBar(
        context,
        'You need to verify your email address first',
      );
      return const LoginPage();
    }
    return const LoginPage();
  }
}
