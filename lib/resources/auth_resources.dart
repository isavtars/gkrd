import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//USers class
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  //signup to the users
  //this is our methods
  Future<String> signUpUser(
      {required email, required password, required confirmPassword}) async {
    String res = "Something went wrong. Please try again.";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          confirmPassword.isNotEmpty) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          //Users/uid/
          ref.child(value.user!.uid.toString()).set({
            'uid': value.user!.uid.toString(),
            'email': value.user!.email.toString(),
            'fullName': '',
            'phoneNumber': '',
            'bankAccNumber': '',
            'age': '',
            'kyc': '',
            'incomeRange': '',
            'profilePic': '',
          });
        });

        res = "Succes";
      } else if (password != confirmPassword) {
        res = "Passwords does not match";
      } else {
        res = "Please enter all fields to proceed.";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //login

  Future<String> loginUsers(
      {required String email, required String password}) async {
    String res = 'Something went wrong. Please try again.';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Sucess";
      } else {
        res = "Please enter your username and password to proceed.";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //resetspasword
  Future<String> resetPassword({required String email}) async {
    String res = "Somrthing went wrong";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = "Sucess";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//logouts
  Future<void> logout() async {
    _auth.signOut();
  }

  //sending veriafaction email
  Future<void> sendVerifactionEmail() async {
    final users = _auth.currentUser!;
    await users
        .sendEmailVerification()
        .then((value) {})
        .onError((error, stackTrace) {});
  }

//checking emailVerifeid

  Future<String> verifierdEmail(
      {required bool verified, required String uid}) async {
    String res = "Something went wrong";
    try {
      if (verified) {
        ref.child(uid).child('split').set({
          "amount": 0,
          'need': 0,
          'expenses': 0,
          'savings': 0,
          'totalBalance': 0,
          'needAvailableBalance': 0,
          'expensesAvailableBalance': 0,
          'count': 1,
          'isEFenabled': false,
          'isCPenabled': false,
          'isAutopayOn': false,
          'targetEmergencyFunds': 0,
          'collectedEmergencyFunds': 0,
        });

        ref.child(uid).child("incexp").set({
          "incomeamount": 0,
          "expensesamount": 0,
          "netAmounts": 0,
        });
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
