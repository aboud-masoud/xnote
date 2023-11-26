import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xtodo/home_screen.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}
