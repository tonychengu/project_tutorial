import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_tutorial/model/user.dart';
import 'package:project_tutorial/util/user_info.dart';

class Functions {
  static void createInboxUser() {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    final UserData user = LocalUserInfo.getLocalUser();
    final data = {
      'name': user.name,
      'date_time': DateTime.now(),
      //'email': _auth.currentUser!.email,
    };
    try {
      _firestore.collection('Users').doc(user.uid).set(data);
    } catch (e) {
      print(e);
    }
  }
}
