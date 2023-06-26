import 'dart:math';

import 'package:flutter/material.dart';

import '../Screen/widgets/custom_buttons.dart';
import '../Screen/widgets/custom_inputs.dart';
import '../styles/color.dart';

class EMICalculator extends StatefulWidget {
  const EMICalculator({super.key});

  @override
  _EMICalculatorState createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  TextEditingController principalController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  double emi = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenColor,
      appBar: AppBar(
        title: const Text('EMI Calculator'),
        backgroundColor: kKarobarcolor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25.0),
              CustomeInputs(
                textEditingController: principalController,
                hintText: 'Principal Amount',
                icons: Icons.attach_money,
                validators: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the principal amount';
                  }
                  return null;
                },
                textinputTypes: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              CustomeInputs(
                textEditingController: interestRateController,
                hintText: 'Interest Rate (%)',
                icons: Icons.monetization_on,
                validators: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the interest rate';
                  }
                  return null;
                },
                textinputTypes: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              CustomeInputs(
                textEditingController: tenureController,
                hintText: 'Tenure (months)',
                icons: Icons.event,
                validators: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the tenure';
                  }
                  return null;
                },
                textinputTypes: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              CustomeBtn(
                  btnTitleName: const Text(
                    'Calculate EMI',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  onPress: calculateEMI),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Rs. ${emi.toStringAsFixed(2)}/mo',
                  style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: kGreenColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateEMI() {
    double principal = double.tryParse(principalController.text) ?? 0.0;
    double interestRate = double.tryParse(interestRateController.text) ?? 0.0;
    double tenure = double.tryParse(tenureController.text) ?? 0.0;

    double monthlyInterestRate = interestRate / 12 / 100;
    double emiNumerator =
        principal * monthlyInterestRate * pow(1 + monthlyInterestRate, tenure);
    double emiDenominator = pow(1 + monthlyInterestRate, tenure) - 1;

    setState(() {
      emi = emiNumerator / emiDenominator;
    });
  }
}
