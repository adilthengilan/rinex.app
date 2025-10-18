import 'package:flutter/material.dart';
import 'package:rinex/src/view/onboard.dart';

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
        fontFamily:
            'Roboto', // You can change this to a custom font if you have one
      ),
      home: OnboardingScreen(),
    );
  }
}
