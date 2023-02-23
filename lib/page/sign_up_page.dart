import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:project_tutorial/util/firestore.dart';

import 'package:project_tutorial/widget/custom_textfield.dart';
import 'package:project_tutorial/widget/snackbar_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

const years = <String>[
  'Freshman',
  'Sophomore',
  'Junior',
  'Senior',
  'Graduate',
  'PhD',
  'PostDoc',
  'Professor',
  'Other'
];

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController minorController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  void signUpUser() async {
    if (passwordController.text != password2Controller.text) {
      showSnackBar(context, 'Passwords do not match');
      return;
    }
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
    final uid = context.watch<User?>()!.uid;
    context.read<FireStoreMethods>().addUserData(context, <String, dynamic>{
      'uid': uid,
      'email': emailController.text,
      'year': yearController.text,
      'major': majorController.text,
      'minor': minorController.text,
      'availableCourses': courseController.text,
      'about': aboutController.text,
      'taughtCount': 0,
      'ratings': 0,
    });
    if (context.read<FirebaseAuthMethods>().isLoggedIn()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Center(
            child: const Text(
              "Sign Up",
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: password2Controller,
              hintText: 'Renter your password',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: majorController,
              hintText: 'Enter your major',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: minorController,
              hintText: 'Enter your minor',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: courseController,
              hintText: 'Enter your courses',
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '  in  MATH101,CS101 format',
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Year',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: years[0],
                  onChanged: (String? newValue) {
                    setState(() {
                      yearController.text = newValue!;
                    });
                  },
                  items: years.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: signUpUser,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
