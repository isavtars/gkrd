import 'package:flutter/material.dart';

class CardAlt extends StatelessWidget {
  const CardAlt({
    super.key,
    required this.orientation,
    required this.constraints,
    required this.title,
    required this.iconName,
  });

  final Orientation orientation;
  final BoxConstraints constraints;
  final String title;
  final IconData iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.01,
          ),
          Icon(
            iconName,
            size: 45,
            color: Colors.white,
          )
        ]),
      ),
    );
  }
}
