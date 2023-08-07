import 'package:flutter/material.dart';
import 'package:gkrd/styles/color.dart';

class GBalanceCardWallet extends StatelessWidget {
  const GBalanceCardWallet({
    super.key,
    required this.amount,
  });

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 150,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Text("Rs.",style: kJakartaBodyBold.copyWith(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w400
          ),),
              Text(
                amount,
                style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              appsname,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
