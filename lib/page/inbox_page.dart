import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green.shade400,
            centerTitle: true,
            title: const Text('Inbox', style: TextStyle(fontSize: 30))),
        body: const Center(child: Text('Check back for new messages!')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          //=> Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (BuildContext context) {
          //   return chat();
          // })),
          child: Icon(Icons.comment),
        ));
  }
}
