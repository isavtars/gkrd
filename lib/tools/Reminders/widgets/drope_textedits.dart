import 'package:flutter/material.dart';

import '../../../styles/color.dart';

Container dropedowncont(
  BoxConstraints constraints, {
  required String value,
  required List<String> list,
  required Function(String?) onpress,
}) {
  return Container(
    width: constraints.maxWidth,
    height: 56,
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color.fromARGB(255, 240, 238, 238)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: kJakartaHeading3.copyWith(fontSize: 15, color: Colors.grey),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            onChanged: onpress,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 0,
            style: const TextStyle(fontSize: 19, color: kGreenColor),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: kJakartaHeading3.copyWith(
                      fontSize: 15, color: kKarobarcolor),
                ),
              );
            }).toList(),
          ),
        )
      ],
    ),
  );
}

Container dropedowncontmini(
  BoxConstraints constraints, {
  required String value,
  required List<String> list,
  required Function(String?) onpress,
}) {
  return Container(
    width: 160,
    height: 56,
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color.fromARGB(255, 240, 238, 238)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: kJakartaHeading3.copyWith(fontSize: 15, color: Colors.grey),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            onChanged: onpress,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 0,
            style: const TextStyle(fontSize: 19, color: kGreenColor),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: kJakartaHeading3.copyWith(
                      fontSize: 15, color: kKarobarcolor),
                ),
              );
            }).toList(),
          ),
        )
      ],
    ),
  );
}
