import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:project_tutorial/util/firestore.dart';

import 'package:project_tutorial/widget/custom_textfield.dart';
import 'package:project_tutorial/widget/snackbar_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestPasswordPage extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const RestPasswordPage({Key? key}) : super(key: key);

  @override
  _RestPasswordPageState createState() => _RestPasswordPageState();
}

class _RestPasswordPageState extends State<RestPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    try {
      context
          .read<FirebaseAuthMethods>()
          .resetPassword(email: emailController.text, context: context);
    } catch (e) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        //padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          AppBar(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Center(
            child: const Text(
              "Reset Password",
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
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: resetPassword,
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
              "Send Email",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
