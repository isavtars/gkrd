import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../styles/color.dart';
import 'login.dart';


class CheckMailScreen extends StatelessWidget {
  const CheckMailScreen({super.key});

  void login() {
    Get.to(const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 160,
            Icons.mark_email_read,
            color: Theme.of(context).cardColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'We have sent you a link to\nreset the password!',
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).cardColor),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: login,
              icon: const Icon(Icons.arrow_forward),
              label: const Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text('Proceed to LOGIN', style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold),),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
              ),
            ),
          )
          // TextButton(onPressed: login, child: const Text('Proceed to LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),))
        ],
      )),
    );
  }
}
