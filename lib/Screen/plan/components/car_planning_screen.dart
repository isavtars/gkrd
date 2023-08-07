import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/Screen/widgets/custom_inputs.dart';
import 'package:gkrd/Screen/widgets/snackbar.dart';

import '../../../styles/color.dart';
import '../../widgets/tools/all_validations.dart';

class CarPlanningScreen extends StatefulWidget {
  const CarPlanningScreen({super.key});

  @override
  State<CarPlanningScreen> createState() => _CarPlanningScreenState();
}

class _CarPlanningScreenState extends State<CarPlanningScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isAutoPayOn = false;
  final carAmountController = TextEditingController();
  final targetPercentageController = TextEditingController();
  final carEmiAmount = TextEditingController();

  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  var now = DateTime.now();

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final double? amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  void activateCarPlan() async {
    DatabaseReference splitRef = ref.child(user.uid).child('split');
    DataSnapshot snapshot = await splitRef.get();
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    dynamic needAvailable = map['needAvailableBalance'];
    // dynamic needSpendings = map['needSpendings'];

    dynamic carAmount = double.tryParse(carAmountController.text);
    dynamic targetSplit =
        double.tryParse(targetPercentageController.text) ?? 20;
    dynamic carEmi = double.tryParse(carEmiAmount.text);

    // calculating 20% of car amount ie Target amount
    dynamic carTargetPercentage = (targetSplit > 0) ? targetSplit / 100.0 : 0.2;
    dynamic carTargetAmount = (carAmount * carTargetPercentage);

    if (needAvailable < carEmi) {
      showSnackBar(text: 'Insufficient balance', color: Colors.red);
    } else {
      if (carEmi > carTargetAmount) {
        showSnackBar(
            text: 'EMI is greater than target amount', color: Colors.red);
      } else {
        dynamic updatedNeedAvail = needAvailable - carEmi;

        final payerData = {
          'needAvailableBalance': updatedNeedAvail,
          'targetCarFunds': carTargetAmount,
          'collectedCarFunds': carEmi,
          'carEmi': carEmi,
          'isCPenabled': true,
          'needSpendings': ServerValue.increment(carEmi),
        };
        splitRef.update(payerData);

        final payer = {
          'name': 'Car Planning EMI',
          'amount': carEmi,
          'paymentDateTime': now.toIso8601String(),
        };
        splitRef.child('needTransactions').push().set(payer);

        String amount = carEmi.toStringAsFixed(0);
        final allTransacPayer = {
          'name': 'Car Planning EMI',
          'amount': '- $amount',
          'paymentDateTime': now.toIso8601String(),
        };
        splitRef.child('allTransactions').push().set(allTransacPayer);

         showSnackBar(
            text: 'EMI is greater than target amount', color: Colors.green);
      }
    }
  }

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
                        horizontal: 20, vertical: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
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
                                'Car plan',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
                        Text(
                        "This is taken from needs by deafualt 20% origin car prices and 10% emi every months",
                            style: kJakartaBodyMedium.copyWith(color: kGrayTextC, fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          const Text(
                            'Enter price of the car',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputsRs(
                            hintText: '8,00,000',
                           
                            textEditingController: carAmountController,
                            validators: checkValidAmounts,
                            textinputTypes: TextInputType.number,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          const Text(
                            'Enter the percentage to get target amount',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                              hintText: '20%',
                              icons: Icons.calculate,
                              textEditingController: targetPercentageController,
                              validators: null,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          const Text(
                            'Enter EMI amount',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                            hintText: '2000',
                            icons: Icons.calculate,
                            textEditingController: carEmiAmount,
                            validators: _validateNumber,
                            textinputTypes: TextInputType.number,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          CustomeBtn(
                            btnTitleName: const Text(
                              'Activate',
                              style: TextStyle(
                                fontSize: 17,
                                color:Colors.white
                              ),
                            ),
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                activateCarPlan();
                              }
                            },
                          ),
                          SizedBox(
                            height: orientation == Orientation.portrait
                                ? constraints.maxHeight * 0.08
                                : constraints.maxHeight * 0.1,
                          ),
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
