import 'package:estate_/src/view/getstart.dart';
import 'package:flutter/material.dart';
 // Create this file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renex App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // You can change this to a custom font if you have one
      ),
      home:  GetStartedScreen(),
    );
  }
}