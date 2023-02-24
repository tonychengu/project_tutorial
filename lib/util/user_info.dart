import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:project_tutorial/util/firestore.dart';

import 'package:project_tutorial/model/user.dart';

class UserInfo {
  static late SharedPreferences prefs;
  static UserData myUser = UserData(
    id: '1',
    name: 'Dooley',
    imagePath:
        'https://i.pinimg.com/originals/4c/f2/32/4cf232c9b64c925a95de471dc61931ce.jpg',
    about: 'It is emory dooley',
    year: 'Senior',
    major: 'Computer Science',
    minor: 'Math',
    availableCourses: "CS101,CS102,CS103,CS104,CS105",
  );

  static Future init() async => {
        prefs = await SharedPreferences.getInstance(),
      };
  static Future saveUser(UserData user, BuildContext context) async {
    final json = jsonEncode(user.toJson());
    //prefs.setString('user', myUser.toJson()),
    await prefs.setString('Local', json);
    final id = context.watch<User?>();
    if (id != null) {
      await FireStoreMethods().updateUserData(context, user.toJson());
    }
  }

  static UserData getUser() {
    final json = prefs.getString('Local');
    if (json != null) {
      return UserData.fromJson(jsonDecode(json));
    } else {
      return myUser;
    }
  }
}
