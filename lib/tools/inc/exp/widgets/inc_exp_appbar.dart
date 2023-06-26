import 'package:flutter/material.dart';

import '../../../../styles/color.dart';

AppBar incExpAppBar(String title) {
  return AppBar(
    backgroundColor: kKarobarcolor,
    elevation: 0,
    title: Text(
      "Add Expenses",
      style:
          kjakartaHeading2.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
    ),
  );
}
