import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/Screen/widgets/custom_inputs.dart';
import 'package:gkrd/Screen/widgets/snackbar.dart';

class AddNewPlanScreen extends StatefulWidget {
  const AddNewPlanScreen({super.key});

  @override
  State<AddNewPlanScreen> createState() => _AddNewPlanScreenState();
}

class _AddNewPlanScreenState extends State<AddNewPlanScreen> {
  double currentValue = 0;
  double investmentYears = 0;

  final _formKey = GlobalKey<FormState>();

  final DatabaseReference stocksRef =
      FirebaseDatabase.instance.ref().child('stocks');

  final user = FirebaseAuth.instance.currentUser!;
  final amountController = TextEditingController();
  final nameController = TextEditingController();

  String? checkValid(value) {
    if (value.isEmpty) {
      return 'This field is required';
    }
    return null;
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
                                'Add new plan',
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
                            'Enter plan name',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                            hintText: 'Plan Name',
                            icons: Icons.description,
                            textEditingController: nameController,
                            validators: checkValid,
                            textinputTypes: TextInputType.text,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
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
                          CustomeInputs(
                              hintText: 'Amount',
                              icons: Icons.currency_rupee,
                              textEditingController: amountController,
                              validators: checkValid,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select number of years',
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
                              max: 50,
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
                                'Select EMI percentage split',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Center(
                                child: Text(
                                  '${investmentYears.toStringAsFixed(2)} %',
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
                              max: 50,
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
                          CustomeBtn(
                              btnTitleName: Text('Continue'),
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  if (investmentYears == 0.0 ||
                                      currentValue == 0.0) {
                                    showSnackBar(
                                        text:
                                            'Please select number of years & EMI percentage split',
                                        color: Colors.red);
                                  } else {
                                    Navigator.of(context).pop();
                                    showSnackBar(
                                        text: 'Data sent successfully!',
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
