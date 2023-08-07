import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/Screen/widgets/custom_inputs.dart';
import 'package:gkrd/Screen/widgets/snackbar.dart';

import '../../../widgets/tools/all_validations.dart';

class AutoInvestmentScreen extends StatefulWidget {
  const AutoInvestmentScreen({super.key});

  @override
  State<AutoInvestmentScreen> createState() => _AutoInvestmentScreenState();
}

class _AutoInvestmentScreenState extends State<AutoInvestmentScreen> {
  double currentValue = 0;
  double investmentYears = 0;

  final _formKey = GlobalKey<FormState>();

  final DatabaseReference stocksRef =
      FirebaseDatabase.instance.ref().child('stocks');

  final user = FirebaseAuth.instance.currentUser!;
  final amountController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.keyboard_backspace),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.03,
                              ),
                              const Text(
                                'Automatic Investment',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select risk capacity range',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Center(
                                child: Text(
                                  currentValue.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                              value: currentValue,
                              min: 0,
                              max: 100,
                              activeColor: Theme.of(context).primaryColor,
                              inactiveColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              onChanged: (value) {
                                setState(() {
                                  currentValue = value;
                                });
                              }),
                          SizedBox(
                            height: constraints.maxHeight * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select years for investment',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Center(
                                child: Text(
                                  investmentYears.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                              value: investmentYears,
                              min: 0,
                              max: 10,
                              activeColor: Theme.of(context).primaryColor,
                              inactiveColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              onChanged: (value) {
                                setState(() {
                                  investmentYears = value;
                                });
                              }),
                          SizedBox(
                            height: constraints.maxHeight * 0.05,
                          ),
                          Text(
                            'Enter amount to invest',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputsRs(
                              hintText: 'Amount',
                           
                              textEditingController: amountController,
                              validators: checkValidAmounts,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.05,
                          ),
                          CustomeBtn(
                              btnTitleName: const Text('Continue',style:TextStyle(
                                color: Colors.white,
                                fontSize: 16
                              ),),
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  if (investmentYears == 0.0 ||
                                      currentValue == 0.0) {
                                    showSnackBar(
                                        text:
                                            'Please select number of years & risk capacity',
                                        color: Colors.red);
                                  } else {
                                    Navigator.of(context).pop();
                                    showSnackBar(
                                        text:
                                            'Please select number of years & risk capacity',
                                        color: Colors.green);
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
