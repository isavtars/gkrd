import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



import '../../resources/auth_resources.dart';
import '../userprofile/update_user_profile.dart';

import '../widgets/checkedemal.dart';
import '../widgets/snackbar.dart';

class VerifeidEmailScreen extends StatefulWidget {
  const VerifeidEmailScreen({super.key});

  @override
  State<VerifeidEmailScreen> createState() => _VerifeidEmailScreenState();
}

class _VerifeidEmailScreenState extends State<VerifeidEmailScreen> {
  bool isVerifiedEmail = false;
  Timer? timer;

  @override
  void initState() {
    isVerifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isVerifiedEmail == false) {
      sendVerificationEmail();

      timer =
          Timer.periodic(const Duration(seconds: 1), (_) => verifactionEmail());
    }
    super.initState();
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) {
      showSnackBar( text: "Success", color: Colors.green);
    }).onError((error, stackTrace) {
      showSnackBar( text: "Error", color: Colors.red);
    });
  }

  verifactionEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();
    final user = FirebaseAuth.instance.currentUser!;
    setState(() {
      isVerifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerifiedEmail == true) {
      timer?.cancel();
      String res = await AuthMethods().verifierdEmail(
          verified: FirebaseAuth.instance.currentUser!.emailVerified,
          uid: user.uid);
      if (res == "Success") {
        // showSnackBar(context, text: res.toString(), color: Colors.green);

        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.toString()),
              backgroundColor: Colors.green,
            ),
          );
        });
      } else {
        // showSnackBar(context, text: res.toString(), color: Colors.red);

        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.toString()),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => isVerifiedEmail
      ? const UserProfileUpdate()
      : WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A verification link has been\nsent to your email!',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).cardColor),
                    textAlign: TextAlign.center,
                  ),
                  CheckEmailWidget(
                      mailText:
                          'You will get automatically logged\nin once you verify your email',
                      btnText: 'Resend Email',
                      onPressed: sendVerificationEmail),
                ],
              ),
            ),
          ),
        );
}

//heloo