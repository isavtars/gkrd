<!-- # GharKharcha

GharKharcha

Home expenses tracking mobile applications are software tools that help individuals and households manage their finances by tracking their spending and expenses. These applications are typically available for smartphones and can be easily downloaded from app stores.
 -->

## GharKharcha (Expense Tracker App)

- ![Test Image 4](https://github.com/isavtars/gk/blob/master/gharkharcha.png)

This repository contains the source code for the GharKharcha Flutter app, which is primarily focused on tracking daily expenses of a home. The app utilizes Firebase for authentication and storage.

### Features

- User authentication with Firebase Authentication
- Login and registration screens
- Forgot password functionality
- Home screen for tracking expenses
- Bottom navigation for easy navigation between screens
- Light and dark theme options
- StreamBuilder for managing user authentication state

### Installation

1. Ensure that Flutter and Dart are installed on your machine.
2. Clone this repository using `git clone [repository-url]`.
3. Open the project in your preferred IDE.
4. Run `flutter pub get` to fetch the project dependencies.
5. Configure Firebase by adding your Firebase project credentials in the `firebase_options.dart` file.
6. Connect a device or start an emulator.
7. Run `flutter run` to launch the app.

### Dependencies

The app relies on the following dependencies:

- `firebase_auth`: For Firebase authentication.
- `firebase_core`: For Firebase core functionality.
- `flutter/material.dart`: For Flutter's material design components.
- `get`: For state management and navigation.
- `gharkhracha/Screen/auth/login.dart`: Login screen for user authentication.
- `gharkhracha/Screen/auth/register_screen.dart`: Registration screen for creating a new account.
- `gharkhracha/Screen/Home/home_screen.dart`: Home screen for tracking daily expenses.
- `gharkhracha/Screen/auth/forgot_password_screen.dart`: Screen for resetting forgotten passwords.
- `gharkhracha/Screen/widgets/bottom_navbar.dart`: Bottom navigation bar for easy navigation.
- `firebase_options.dart`: Configuration file for Firebase credentials.
- `logic/themes_changer.dart`: Logic for managing theme modes.
- `styles/gharkharcha_themes.dart`: Custom themes for the app.

### Usage

Upon launching the GharKharcha app, you will encounter a login screen. If you don't have an account, you can navigate to the registration screen to create one. After logging in, you will be directed to the home screen, where you can track your daily expenses. The app provides a bottom navigation bar for seamless navigation between screens. You can switch between light and dark themes based on your preference.

### Contributions

Contributions to this project are welcome! If you find any bugs or want to add new features, feel free to open an issue or submit a pull request.

### Acknowledgements

The GharKharcha app was developed with Flutter and utilizes the following packages:

- Firebase: For authentication and storage.
- Get X: For state management and navigation.

Special thanks to the contributors and the Flutter community for their support and contributions.

Please note that the GharKharcha app is developed for learning purposes and may not be suitable for production environments.
