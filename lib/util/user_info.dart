import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_tutorial/util/firebase_auth.dart';
import 'package:project_tutorial/util/firestore.dart';

import 'package:project_tutorial/model/user.dart';

class LocalUserInfo {
  static late SharedPreferences prefs;
  static UserData myUser = UserData(
    uid: '1',
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
        //myUser = getLocalUser(),
      };
  static Future saveUser(UserData user, BuildContext context,
      {bool signup = false}) async {
    myUser = user;
    final json = jsonEncode(user.toJson());
    //prefs.setString('user', myUser.toJson()),
    await prefs.setString('Local', json);
    await saveRemoteUser(user, context, signup: signup);
  }

  static Future saveRemoteUser(UserData user, BuildContext context,
      {bool signup = false}) async {
    final uid = context.read<User?>()!.uid;
    if (uid != null && !signup) {
      await context
          .read<FireStoreMethods>()
          .updateUserData(context, user.toJson());
    } else if (uid != null && signup) {
      await context
          .read<FireStoreMethods>()
          .addUserData(context, user.toJson());
    }
  }

  static UserData getLocalUser() {
    final json = prefs.getString('Local');
    if (json != null) {
      return UserData.fromJson(jsonDecode(json));
    } else {
      return myUser;
    }
  }

  // static Future<UserData> getRemoteUser(BuildContext context) async {
  //   final uid = context.read<User?>()!.uid;
  //   if (uid != null) {
  //     QuerySnapshot snapshot =
  //         await context.read<FireStoreMethods>().getUserByUid(uid);
  //   }
  //   return myUser;
  // }

  static void clearUser() {
    prefs.remove('Local');
  }

  static Future loginUser(String uid) async {
    QuerySnapshot snapshot = await FireStoreMethods().getUserByUid(uid);
    if (snapshot.docs.isNotEmpty) {
      final json = snapshot.docs.first.data() as Map<String, dynamic>;
      myUser = UserData.fromJson(json);
      //await saveUser(user, context);
      await prefs.setString('Local', jsonEncode(myUser.toJson()));
    }
  }
}
