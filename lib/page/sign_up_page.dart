import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:project_tutorial/util/firestore.dart';
import 'package:project_tutorial/util/user_info.dart';

import 'package:project_tutorial/widget/custom_textfield.dart';
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/snackbar_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_tutorial/model/user.dart';

import 'package:project_tutorial/Logics/functions.dart';

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
  'Other'
];

String? validateEmory(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@emory.edu';
  final regex = RegExp(pattern);
}

String? validatePassword(String? value) {
  const pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
  final regex = RegExp(pattern);
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController minorController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController imagePath = TextEditingController();
  static String year = 'Freshman';

  void signUpUser() async {
    if (passwordController.text != password2Controller.text) {
      showSnackBar(context, 'Passwords do not match');
      return;
    }
    await context.read<FirebaseAuthMethods>().signUpWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
    final uid = context.read<User?>()!.uid;
    final json = <String, dynamic>{
      'uid': uid,
      'name': nameController.text,
      'email': emailController.text,
      'year': year,
      'major': majorController.text,
      'minor': minorController.text,
      'availableCourses': courseController.text,
      'about': aboutController.text,
      'taughtCount': 0,
      'ratings': 0,
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/cs370-329f4.appspot.com/o/profileImg.png?alt=media',
      'balance': 1,
      'fullPath': ''
    };
    // remove all spaces from courses
    json['availableCourses'] = json['availableCourses'].replaceAll(' ', '');
    await LocalUserInfo.saveUser(UserData.fromJson(json), context,
        signup: true);
    Functions.createInbox();
    //context.read<FireStoreMethods>().addUserData(context, json);
    if (context.read<FirebaseAuthMethods>().isLoggedIn()) {
      Navigator.of(context).pop();
    }
/*
    Navigator.of(context).push(//???
        MaterialPageRoute(builder: (BuildContext context) {}));
        */
    //send back to login page?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        //padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          AppBar(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const Center(
            child: Text(
              "Sign Up",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: validateEmory,
                controller: emailController,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Enter your Emory email',
                    hintText: 'Must end in @emory.edu',
                    prefixIcon: Icon(Icons.mail))),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: validatePassword,
              controller: passwordController,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Must be at least 8 characters',
                labelText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: password2Controller,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Must be at least 8 characters',
                labelText: 'Re-enter your password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Full name',
                labelText: 'Enter your full name',
                prefixIcon: Icon(Icons.mood_rounded),
              ),
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
          // const SizedBox(height: 24),
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 20),
          //   child: CustomTextField(
          //     controller: minorController,
          //     hintText: 'Enter your second major or minor',
          //   ),
          // ),
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
              '  in  MATH101, CS101 format',
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
                  value: year,
                  onChanged: (String? newValue) {
                    setState(() {
                      //yearController.text = newValue!;
                      year = newValue!;
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
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: aboutController,
              hintText: 'Write a self description',
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: signUpUser,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green.shade300),
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
          const SizedBox(height: 86),
        ],
      ),
    );
  }
}
