import 'package:flutter/material.dart';

class NoFoundPage extends StatelessWidget {
  const NoFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Found Page"),
      ),
    );
  }
}
