import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/color.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_inputs.dart';
import '../widgets/snackbar.dart';
import 'budget_home_screen.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final needController = TextEditingController();
  final expensesController = TextEditingController();
  final savingsController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  DateTime now = DateTime.now();

  String? checkValid(value) {
    if (value.isEmpty || value == null) {
      return 'Enter amount first';
    } else if (value == "-") {
      return 'Enter amount first -';
    }
    return null;
  }

  void add() async {
    if (_formKey.currentState!.validate()) {
      double? totalAmount = double.tryParse(amountController.text) ?? 0.0;
      double? amount = double.tryParse(amountController.text);
      double? need = double.tryParse(needController.text) ?? 50.0;
      double? expenses = double.tryParse(expensesController.text) ?? 30.0;
      double? savings = double.tryParse(savingsController.text) ?? 10.0;

      if (amount == null) {
        showSnackBar(text: "Please enter the amount", color: Colors.red);
      }

      if ((need + expenses + savings) == 100.0) {
        // Calculate amounts based on the split percentages or taking default percentages
        double needPercent = (need >= 0) ? need / 100.0 : 0.5;
        double expensesPercent = (expenses >= 0) ? expenses / 100.0 : 0.3;
        double savingsPercent = (savings >= 0) ? savings / 100.0 : 0.1;

        double needAmount = amount! * needPercent;
        double expensesAmount = amount * expensesPercent;
        double savingsAmount = amount * savingsPercent;

        //Users/uid/split

        DatabaseReference splitRef = ref.child(user.uid).child('split');

        splitRef.update(
          {
            'amount': ServerValue.increment(amount),
            'need': ServerValue.increment(needAmount),
            'expenses': ServerValue.increment(expensesAmount),
            'savings': ServerValue.increment(savingsAmount),
            'totalBalance': totalAmount,
            'needAvailableBalance': ServerValue.increment(needAmount),
            'expensesAvailableBalance': ServerValue.increment(expensesAmount),
          },
        ).then(
          (value) async {
            DatabaseReference expensesRef = ref.child(user.uid).child('split');
            DataSnapshot snapshot = await expensesRef.get();
            Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
            bool isEFenabled = map['isEFenabled'];
            if (isEFenabled) {
              var expenses = map['expenses'];
              var count = map['count'];
              var expensesMultiplier = map['expensesMultiplier'];

              dynamic targetEmergencyFunds =
                  ((expenses / count) * expensesMultiplier);

              final payerAlt = {
                'count': ServerValue.increment(1),
                'targetEmergencyFunds': targetEmergencyFunds,
              };
              expensesRef.update(payerAlt);
            }

            final payer = {
              'name': 'Funds added!',
              'amount': '+ ${amountController.text}',
              'paymentDateTime': now.toIso8601String(),
            };

            ref
                .child(user.uid)
                .child('split')
                .child('allTransations')
                .push()
                .set(payer);

            // ignore: use_build_context_synchronously
            showSnackBar(text: 'Added!', color: Colors.green);
          },
        ).onError(
          (error, stackTrace) {
            showSnackBar(text: error.toString(), color: Colors.red);
          },
        );

        // ignore: use_build_context_synchronously
        Navigator.pop(context,
            MaterialPageRoute(builder: (context) => const BHomeScreen()));
      } else {
        showSnackBar(text: 'calculated 100%', color: Colors.red);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    needController.dispose();
    expensesController.dispose();
    savingsController.dispose();
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
                      horizontal: 20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.02),
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
                                'Add Funds',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          const Text(
                            'Enter amount',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          CustomeInputs(
                              textEditingController: amountController,
                              hintText: "Amount",
                              icons: Icons.currency_rupee_outlined,
                              textinputTypes: TextInputType.number,
                              validators: checkValid,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          const Text(
                            'Enter the percentage split for Needs',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          CustomeInputs(
                              textEditingController: needController,
                              hintText: "50%",
                              icons: Icons.calculate,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          const Text(
                            'Enter the percentage split for Expenses',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          CustomeInputs(
                              textEditingController: expensesController,
                              hintText: "30%",
                              icons: Icons.calculate,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          const Text(
                            'Enter the percentage split for Savings',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          CustomeInputs(
                              textEditingController: savingsController,
                              hintText: "20%",
                              icons: Icons.calculate,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          const Text(
                            'If the split percentage for Needs, Expenses and Savings are not given it will be taken as 50%, 30% and 20% respectively.',
                            style: TextStyle(color: kGrayTextC, fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.04),
                          TButton(
                              // constraints: constraints,
                              btnColor: Theme.of(context).primaryColor,
                              btnText: 'Add',
                              onPressed: () async {
                                add();
                              }),
                          SizedBox(
                              height: orientation == Orientation.portrait
                                  ? constraints.maxHeight * 0.1
                                  : constraints.maxHeight * 0.1),
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
