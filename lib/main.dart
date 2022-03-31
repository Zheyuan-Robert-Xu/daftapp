import 'package:daftapp/display/page/AnimationScreen.dart';
import 'package:daftapp/display/page/ChartsScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      // home: const AnimationScreen(),
      home: const ChartsScreen(),
    );
  }
}
