import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_tutorial/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  //static SharedPreferences prefs;
  static User myUser = User(
    id: '1',
    name: 'Swoop',
    imagePath:
        'https://i.pinimg.com/originals/4c/f2/32/4cf232c9b64c925a95de471dc61931ce.jpg',
    about: 'I am Swoop',
    year: 'Freshman',
    major: 'French',
    minor: 'Philosophy',
    availableCourses: "PHIL400,FREN102,FREN201,PHIL220,PHIL190",
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
