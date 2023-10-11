import 'package:flutter/material.dart';

import '../../styles/color.dart';
import '../../styles/sizeconfig.dart';

class CustomeBtn extends StatelessWidget {
  const CustomeBtn({
    super.key,
    required this.btnTitleName,
    required this.onPress,
    this.backgroundColor = kKarobarcolor,
  });
  final Widget btnTitleName;
  final VoidCallback onPress;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 55,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: btnTitleName,
        ),
      ),
    );
  }
}

class TButton extends StatelessWidget {
  const TButton(
      {super.key,
      this.loading = false,
      this.constraints,
      required this.btnColor,
      required this.btnText,
      required this.onPressed});

  final BoxConstraints? constraints;
  final Color btnColor;
  final String btnText;
  final Function() onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 53,
      // height: constraints.maxHeight * 0.074,
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                btnText,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
      ),
    );
  }
}
