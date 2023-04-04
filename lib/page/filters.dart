import 'package:flutter/material.dart';
// model import
import 'package:project_tutorial/model/user.dart';
// util import
import 'package:project_tutorial/util/user_info.dart';
import 'package:project_tutorial/util/firestore.dart';
// widget import
import 'package:project_tutorial/widget/profile_widget.dart';
import 'package:project_tutorial/widget/numbers_widget.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  bool checkedValue = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.green[300],
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        title: const Text(
          'Filters',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Search: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 315,
                        child: TextField(
                          maxLines: 1,
                          controller: controller,
                          decoration: const InputDecoration(
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black)),
                            hintText: 'Enter a name, major, or course',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Only show favorites: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Checkbox(
                            value: checkedValue,
                            onChanged: (value) => setState(
                              () {
                                checkedValue = value!;
                              },
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(controller.text);
                          //also save checkbox state
                        },
                        child: Text('Save changes'),
                      ),
                      //submit button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
