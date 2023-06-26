import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.black
          .withOpacity(0.1), // Set the background color with opacity
      child: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Image.asset(
          'assets/images/splash.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
