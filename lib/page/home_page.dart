import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // means in the center
    return Center(child: ElevatedButton(onPressed: () {}, child: Text("Halo")));
  }
}
