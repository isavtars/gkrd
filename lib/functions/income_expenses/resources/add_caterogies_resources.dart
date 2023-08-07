//firebase add caterogies

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// void addCategory(BuildContext context, String categoryName, String categoryType,) async {

//   var rng = Random();
//   var k = rng.nextInt(10000);

//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Map<String, dynamic> categoryData = {
//        'categoryName': categoryName,
//     'categoryType': categoryType,

//   };

//   await _firestore
//       .collection("caterogies")
//       .doc("$k")
//       .set(categoryData)
//       .then((value) {
//     Get.back();
//   }).onError((error, stackTrace) {
//     showSnackBar(context, text: error.toString(), color: Colors.red);
//   });

// }

final databaseRef = FirebaseDatabase.instance.ref();

void addCategory() {
  debugPrint('This functions works');
  databaseRef.child('caterogies').push().set({
    'CaterogiesName': 'Recharge',
    'CaterogiesType': 'Expenses',
  }).then((value) {
    debugPrint('Data added successfully.');
  }).catchError((error) {
    debugPrint('Failed to add data: $error');
  });
}
