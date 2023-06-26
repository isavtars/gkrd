import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'storage_methods.dart';

class UserMethods {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  Future<String> updateUserData(
      {required String uid,
      required String fullName,
      required String phoneNumber,
      required String bankAccNumber,
      required String age,
      required String kyc,
      required String incomeRange,
      required Uint8List picfile}) async {
    String res = "Something went wrong.";

    String profilePic =
        await StorageMehods().uplodaImages('profilePicture', picfile);

    try {
      if (fullName.isNotEmpty ||
          phoneNumber.isNotEmpty ||
          bankAccNumber.isNotEmpty ||
          age.isNotEmpty ||
          kyc.isNotEmpty ||
          incomeRange.isNotEmpty ||
          picfile.isNotEmpty) {
        //Users/uid

        await ref
            .child(_auth.currentUser!.uid)
            .update({
              'fullName': fullName,
              'phoneNumber': phoneNumber,
              'bankAccNumber': bankAccNumber,
              'age': age,
              'kyc': kyc,
              'incomeRange': incomeRange,
              'profilePic': profilePic,
            })
            .then((value) {})
            .onError((error, stackTrace) {});
        res = "Success";
      } else {
        res = "Please enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
