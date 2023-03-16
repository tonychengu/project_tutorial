import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green.shade300,
            automaticallyImplyLeading: false,
            title: const Text('Search', style: TextStyle(fontSize: 30))),
        body: const Center(child: Text('')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {}, //insert connection to comment bar
          child: Icon(Icons.comment),
        ));
  }
}
