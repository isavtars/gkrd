import 'package:flutter/material.dart';

import '../../styles/color.dart';
import '../../styles/sizeconfig.dart';

class CustomeInputs extends StatelessWidget {
  const CustomeInputs(
      {super.key,
      this.textEditingController,
      required this.hintText,
      required this.icons,
      this.validators,
      required this.textinputTypes,
      this.credentials = false,
      this.inputFormatters});

  final TextEditingController? textEditingController;
  final String hintText;
  final IconData icons;
  final dynamic validators;
  final TextInputType textinputTypes;
  final bool credentials;
  final dynamic inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
      child: TextFormField(
        obscureText: credentials ? true : false,
        validator: validators,
        controller: textEditingController,
        style: const TextStyle(color: kGrayTextC),
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: textinputTypes,
        decoration: InputDecoration(
            hintStyle: const TextStyle(color: kGrayC, fontSize: 16),
            prefixIcon: Icon(
              icons,
              color: kGrayC,
              size: 20,
            ),
          
            hintText: hintText,
          
            hoverColor: kGreenColor,
            focusColor: kKarobarcolor,
            filled: true,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder:
                Theme.of(context).inputDecorationTheme.focusedBorder),
      ),
    );
  }
}

class CustomeInputWithdrop extends StatelessWidget {
  const CustomeInputWithdrop({
    super.key,
    this.titleController,
    required this.hintText,
    required this.suffix,
    required this.perfix,
  });

  final TextEditingController? titleController;

  final String hintText;
  final Widget suffix;
  final IconData perfix;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text("Rs.",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300
                  ),),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 4,
                ),
                Text(
                  hintText,
                  style: kJakartaHeading4.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4),
                ),
              ],
            ),
            suffix
          ]),
        ));
  }
}


///custome ouput input With Rs

class CustomeInputsRs extends StatelessWidget {
  const CustomeInputsRs(
      {super.key,
      this.textEditingController,
      required this.hintText,
     
      this.validators,
      required this.textinputTypes,
      this.credentials = false,
      this.inputFormatters});

  final TextEditingController? textEditingController;
  final String hintText;
  
  final dynamic validators;
  final TextInputType textinputTypes;
  final bool credentials;
  final dynamic inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
      child: TextFormField(
        obscureText: credentials ? true : false,
        validator: validators,
        controller: textEditingController,
        style: const TextStyle(color: kGrayTextC),
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: textinputTypes,
        decoration: InputDecoration(
            hintStyle: const TextStyle(color: kGrayC, fontSize: 16),
           
            prefix:const Text ("Rs.") ,
            hintText: hintText,
          
            hoverColor: kGreenColor,
            focusColor: kKarobarcolor,
            filled: true,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder:
                Theme.of(context).inputDecorationTheme.focusedBorder),
      ),
    );
  }
}