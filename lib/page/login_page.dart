// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// utils
import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:project_tutorial/util/user_info.dart';

// pages
import 'package:project_tutorial/main.dart';
import 'package:project_tutorial/page/home_page.dart';
import 'package:project_tutorial/page/sign_up_page.dart';
import 'package:project_tutorial/page/reset_password.dart';

// widgets
import 'package:project_tutorial/widget/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    await context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
    await LocalUserInfo.loginUser(context
        .read<User?>()!
        .uid); //error on login click if user doesn't enter email/password
    if (context.read<FirebaseAuthMethods>().isLoggedIn()) {
      Navigator.of(context).push(
        // OR onPressed: () async { await Navigator.push(...);  await anyOtherMethod(); }
        MaterialPageRoute(
          builder: (BuildContext context) {
            return RootPage();
          },
        ),
      );
    }
  }

  Future<void> debugloginUser() async {
    await context.read<FirebaseAuthMethods>().loginWithEmail(
          email: "test2@emory.edu",
          password: "123123",
          context: context,
        );
    await LocalUserInfo.loginUser(context.read<User?>()!.uid);
    if (context.read<FirebaseAuthMethods>().isLoggedIn()) {
      Navigator.of(context).push(
        // OR onPressed: () async { await Navigator.push(...);  await anyOtherMethod(); }
        MaterialPageRoute(
          builder: (BuildContext context) {
            return RootPage();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.mail))),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: loginUser,
              child: const Text('Login'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.green.shade300),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
            ),
            const SizedBox(height: 24),
            /*
            ElevatedButton(
              onPressed: debugloginUser,
              child: const Text('Debug Login'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
            )
            ,
            const SizedBox(height: 24),*/
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                // OR onPressed: () async { await Navigator.push(...);  await anyOtherMethod(); }
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SignUpPage();
                  },
                ),
              ),
              child: const Text('Sign Up'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.green.shade300),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                // OR onPressed: () async { await Navigator.push(...);  await anyOtherMethod(); }
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return RestPasswordPage();
                  },
                ),
              ),
              child: const Text('Forgot Password?'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.green.shade300),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
