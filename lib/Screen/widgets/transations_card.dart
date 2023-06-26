import 'package:flutter/material.dart';

import '../../styles/color.dart';

class TransationsCards extends StatelessWidget {
  const TransationsCards({
    super.key,
    required this.dateTime,
    required this.title,
    required this.amount,
  });

  final String dateTime;
  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.currency_rupee),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: kJakartaHeading4.copyWith(),
                ),
                Text(
                  dateTime,
                  style: kJakartaHeading4.copyWith(),
                ),
              ],
            ),
            Text(
              amount,
              style: kJakartaBodyRegular.copyWith(),
            )
          ]),
    );
  }
}
