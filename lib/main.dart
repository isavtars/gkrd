import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gkrd/styles/color.dart';
import 'package:timezone/data/latest_10y.dart';

import 'Screen/Budgets/budget_home_screen.dart';
import 'Screen/Dashboard/dashboard_screen.dart';
import 'Screen/auth/forgot_password_screen.dart';
import 'Screen/auth/login.dart';
import 'Screen/auth/register_screen.dart';
import 'Screen/splash_screen.dart';

import 'firebase_options.dart';
import 'logic/binding/my_binding.dart';
import 'logic/themes_changer.dart';
import 'styles/gharkharcha_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
 SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.light,
      statusBarColor: kKarobarcolor, systemNavigationBarColor: kKarobarcolor));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ThemModeChange(),
      builder: (themcontroller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // initialRoute: '/splashScreen',
          initialBinding: MyBinding(),
          themeMode: themcontroller.themeMode,
          theme: GkThemsData.lightTheme,
          darkTheme: GkThemsData.darkTheme,
          getPages: [
            GetPage(name: "/splashScreen", page: () => const SplashScreen()),
            GetPage(name: "/register", page: () => const RegisterScreen()),
            GetPage(name: "/login", page: () => const LoginScreen()),
            GetPage(
                name: "/forgot_password", page: () => const ForgotPassScreen()),
            GetPage(name: "/home", page: () => const BHomeScreen()),
          ],
          defaultTransition: Transition.cupertino,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Checking if the snapshot has any data or not
                if (snapshot.hasData) {
                  debugPrint("${snapshot.hasData}hello this the data");
                  // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                  return const Dashboard();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              // means connection to future hasnt been made yet
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
