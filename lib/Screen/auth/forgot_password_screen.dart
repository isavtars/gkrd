import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../styles/color.dart';
import '../../styles/sizeconfig.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_inputs.dart';
import '../widgets/snackbar.dart';
import 'check_mainscreen.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgotPassScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  // void resetPassword(){

  // }
  void forgotPassword() {
    setState(() {
      isLoading = true;
    });
    _auth
        .sendPasswordResetEmail(email: emailController.text.toString())
        .then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CheckMailScreen()));
      showSnackBar(
          text: "Password reset email sent!", color: Colors.green);
      setState(() {
        isLoading = false;
      });
    }).onError((err, stackTrace) {
      showSnackBar( text: err.toString(), color: Colors.red);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    debugPrint("${SizeConfig.blockSizeVertical}");
    debugPrint("${SizeConfig.blockSizeHorizontal}");

    return Scaffold(
      backgroundColor: kGreenColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/gharkharcha.png',
                      ))),
              height: SizeConfig.blockSizeVertical! * 55,
            ),
            Container(
              height: SizeConfig.blockSizeVertical! * 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    Text(
                      "Forgot Password",
                      style: kJakartaBodyMedium.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 6.3),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2.5,
                    ),
                    Form(
                      key: _formKey,
                      child: CustomeInputs(
                        textEditingController: emailController,
                        hintText: "Email",
                        icons: Icons.alternate_email,
                        textinputTypes: TextInputType.emailAddress,
                        validators: (value) {
                          if (value!.isEmpty) {
                            return "Enter the email";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 1.0,
                    ),
                    Text('\tA password reset link will be sent to this email.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kJakartaBodyMedium.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: SizeConfig.blockSizeHorizontal! * 4.1)),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2.5,
                    ),
                    CustomeBtn(
                      btnTitleName: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Reset Password"),
                      onPress: forgotPassword,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2.2,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
