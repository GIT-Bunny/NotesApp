import 'package:flutter/material.dart';
import 'package:notes_ui/mainScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        accentColor: Colors.amber[400],
      ),
      home: MainScreen(),
    );
  }
}
