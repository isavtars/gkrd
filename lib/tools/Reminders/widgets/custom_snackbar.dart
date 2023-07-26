
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String text;

  const CustomSnackBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green, // Set the background color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, // Set the text color
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

