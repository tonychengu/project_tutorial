import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const CustomNotification(
      {Key? key,
      required this.title,
      required this.message,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(message, style: TextStyle(fontSize: 14.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}