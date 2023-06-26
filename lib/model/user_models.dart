

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String uid;
  final String fullName,
      phoneNumber,
      bankAccNumber,
      age,
      kyc,
      incomeRange,
      profilePic;

  Users(
      {required this.fullName,
      required this.phoneNumber,
      required this.bankAccNumber,
      required this.age,
      required this.kyc,
      required this.incomeRange,
      required this.profilePic,
      required this.email,
      required this.uid});

  //make to jsons
  Map<String, dynamic> toJson() => {
        "email": email,
        'uid': uid,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'bankAccNumber': bankAccNumber,
        'age': age,
        'kyc': kyc,
        'incomeRange': incomeRange,
        'profilePic': profilePic,
      };

  //retrive the date to the models
  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Users(
      email: snapshot["email"],
      uid: snapshot["uid"],
      fullName: snapshot["fullName"],
      phoneNumber: snapshot["phoneNumber"],
      bankAccNumber: snapshot["bankAccNumber"],
      age: snapshot["age"],
      kyc: snapshot["kyc"],
      incomeRange: snapshot["incomeRange"],
      profilePic: snapshot["profilePic"],
    );
  }
}
