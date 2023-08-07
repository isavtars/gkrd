import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/auth_resources.dart';
import '../../styles/color.dart';
import '../../styles/sizeconfig.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_inputs.dart';
import '../widgets/tools/all_validations.dart';
// import '../widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formGlobal = GlobalKey<FormState>();

  bool _isLoading = false;

//login Screenn

  void login() async {
    if (_formGlobal.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
    }

    String res = await AuthMethods().loginUsers(
        email: emailController.text, password: passwordController.text);

    if (res != "Sucess") {
      // showSnackBar(context,text: res, color: Colors.red);

      Future<void>.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.toString()),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      _formGlobal.currentState!.reset();
      
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
              height: SizeConfig.blockSizeVertical! * 43,
              // child: Center(child: Image.asset('assets/images/gharkharcha new.png')),
            ),
            Container(
              height: SizeConfig.blockSizeVertical! * 57,
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
                      height: SizeConfig.blockSizeVertical! * 2.3,
                    ),
                    Text(
                      "Log in\nto your account",
                      style: kJakartaBodyMedium.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 6.3),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2.5,
                    ),
                    Form(
                        key: _formGlobal,
                        child: Column(
                          children: [
                            CustomeInputs(
                              textEditingController: emailController,
                              hintText: "Email",
                              icons: Icons.alternate_email,
                              textinputTypes: TextInputType.emailAddress,
                              validators: emailValidations
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 2,
                            ),
                            CustomeInputs(
                              validators: (value) {
                                if (value!.isEmpty) {
                                  return "Enter The password";
                                }
                                return null;
                              },
                              textinputTypes: TextInputType.text,
                              textEditingController: passwordController,
                              hintText: "Password",
                              icons: Icons.lock,
                              credentials: true,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2,
                    ),
                    CustomeBtn(
                      btnTitleName: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "LOGIN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      onPress: login,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2.2,
                    ),
                    Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "New to the GharKharcha ?",
                            style: kJakartaBodyRegular.copyWith()),
                        TextSpan(
                            text: "\tRegister",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed("/register"),
                            style:
                                kJakartaBodyRegular.copyWith(color: kGreenColor))
                      ])),
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Get.toNamed('/forgot_password');
                          },
                          child: Text("Forgot password ?",
                              style: kJakartaBodyRegular.copyWith(
                                  color: kGreenColor))),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
