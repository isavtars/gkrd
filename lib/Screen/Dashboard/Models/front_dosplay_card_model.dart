import 'package:flutter/material.dart';

class DisplayCardModes {
  final IconData icons;
  final String prices;
  final String cardTitle;
  final Color icconBgColor;

  DisplayCardModes(
      {required this.icons,
      required this.prices,
      required this.cardTitle,
      required this.icconBgColor});
}

List<DisplayCardModes> dispalycarddemo = [
  DisplayCardModes(
    icons: Icons.receipt,
    prices: "160,000",
    cardTitle: "To given",
    icconBgColor: Colors.green,
  ),
  DisplayCardModes(
    icons: Icons.wallet,
    prices: "60,000",
    cardTitle: "To burrow",
    icconBgColor: Colors.red,
  ),
  DisplayCardModes(
    icons: Icons.near_me,
    prices: "40,000",
    cardTitle: "Near_Me",
    icconBgColor: Colors.blue,
  ),
  DisplayCardModes(
    icons: Icons.wallet,
    prices: "20,000",
    cardTitle: "To burrow",
    icconBgColor: Colors.purple,
  ),
  DisplayCardModes(
    icons: Icons.wallet,
    prices: "10,000",
    cardTitle: "To burrow",
    icconBgColor: Colors.red,
  ),
];
