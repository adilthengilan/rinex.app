import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rinex/src/view/onboard.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  void initState() {
    super.initState();
    // Navigate to home after delay
    Timer(Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E88E5), // Lighter blue at top
              Color(0xFF1976D2), // Darker blue at bottom
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacer
              const Expanded(flex: 2, child: SizedBox()),

              // Centered RenX Logo
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        // BoxShadow(
                        //   color: Colors.black.withOpacity(0.3),
                        //   spreadRadius: 2,
                        //   blurRadius: 10,
                        //   offset: const Offset(0, 5),
                        // ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/renex-logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback widget if image fails to load
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom spacer
              const Expanded(flex: 1, child: SizedBox()),

              // Get Started button
              Padding(
                padding: EdgeInsets.all(size.height / 15),
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
