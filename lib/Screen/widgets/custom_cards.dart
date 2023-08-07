import 'package:flutter/material.dart';

class BlanceCard extends StatelessWidget {
  const BlanceCard(
      {super.key,
      required this.height,
      required this.width,
      required this.cardTitle,
      required this.cardBalance,
      required this.color});

  final double height;
  final double width;
  final String cardTitle;
  final String cardBalance;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  cardTitle,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Rs."),
                    Text(
                      cardBalance,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
