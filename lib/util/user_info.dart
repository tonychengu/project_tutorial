import 'package:project_tutorial/model/user.dart';

class UserInfo {
  static User myUser = User(
    id: '1',
    name: 'Dooley',
    imagePath:
        'https://i.pinimg.com/originals/4c/f2/32/4cf232c9b64c925a95de471dc61931ce.jpg',
    about: 'It is emory dooley',
    year: 'Senior',
    major: 'Computer Science',
    minor: 'Math',
    availableCourses: [
      'CS 100',
      'CS 101',
      'CS 102',
      'CS 103',
      'CS 104',
    ],
  );
}
