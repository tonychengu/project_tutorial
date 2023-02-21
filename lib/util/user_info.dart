import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_tutorial/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  //static SharedPreferences prefs;
  static User myUser = User(
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
        //prefs = await SharedPreferences.getInstance(),
        //myUser = User.fromJson(prefs.getString('user') ?? ''),
      };
  static Future saveUser(User user) async {
    final json = jsonEncode(user.toJson());
    //prefs.setString('user', myUser.toJson()),
    //await prefs.setString('Local', json);
  }

  static User getUser() {
    //final json = prefs.getString('Local');
    //if (json != null) {
    //  return User.fromJson(jsonDecode(json));
    //} else {
    return myUser;
  }
}
