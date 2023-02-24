import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import model
import 'package:project_tutorial/model/user.dart';
// import util
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';
// import widget
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/textfield_widget.dart';
import 'package:project_tutorial/widget/button_widget.dart';
// import dependency
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late UserData user;

  @override
  void initState() {
    super.initState();

    user = UserInfo.getUser();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            ProfileWidget(
              imagePath: user.imagePath,
              isEdit: true,
              onClicked: () async {
                final image =
                    await ImagePicker().getImage(source: ImageSource.gallery);
                if (image == null) return;

                final directory = await getApplicationDocumentsDirectory();
                final path = File('${directory.path}/profileImg.png');
                final newImage = await File(image.path).copy(path.path);

                setState(() => user = user.copy(imagePath: newImage.path));
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Full Name',
              text: user.name,
              onChanged: (name) => user = user.copy(name: name),
            ),
            const SizedBox(height: 24),
            // TextFieldWidget(
            //   label: 'Year',
            //   text: user.year,
            //   onChanged: (year) {},
            // ),
            Text(
              'Year',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: user.year,
              onChanged: (String? newValue) {
                setState(() {
                  user = user.copy(year: newValue!);
                });
              },
              items: years.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Major',
              text: user.major,
              onChanged: (major) => user = user.copy(major: major),
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Minor',
              text: user.minor ?? '',
              onChanged: (minor) => user = user.copy(minor: minor),
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Available Courses (in  "MATH101,CS101" format) ',
              text: user.availableCourses,
              onChanged: (courses) => user = user.updateAvlCourses(courses),
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'About',
              text: user.about ?? '',
              maxLines: 5,
              onChanged: (about) => user = user.copy(about: about),
            ),
            const SizedBox(height: 24),
            ButtonWidget(
                text: 'Save',
                onClicked: () {
                  UserInfo.saveUser(user, context);
                  Navigator.of(context).pop();
                })
          ],
        ),
      );
}
