import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/Screen/widgets/snackbar.dart';

import '../../widgets/custom_inputs.dart';
import '../../widgets/tools/all_validations.dart';

class AddExpensesPayer extends StatefulWidget {
  const AddExpensesPayer({super.key});

  @override
  State<AddExpensesPayer> createState() => _AddExpensesPayerState();
}

class _AddExpensesPayerState extends State<AddExpensesPayer> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  final user = FirebaseAuth.instance.currentUser!;

  DateTime now = DateTime.now();

  final _formKey = GlobalKey<FormState>();

// Controllers for texfields
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final accountNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final shortDescriptionController = TextEditingController();



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

 

  void _addAndPay() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference needIncomeRef = ref.child(user.uid).child('split');

      DataSnapshot snapshot = (await needIncomeRef
          .child('expensesAvailableBalance')
          .get()) as dynamic;

      var currentExpensesAvail = (snapshot.value) as dynamic;

      if (double.parse(amountController.text) > currentExpensesAvail) {
        showSnackBar(text: 'Insufficient Balance', color: Colors.red);
      } else {
        // Check if payer already exists
        DataSnapshot payerSnapshot = await needIncomeRef
            .child('expensesPayers')
            .orderByChild('accountNumber')
            .equalTo(accountNumberController.text)
            .get() as dynamic;

        final payerData = {
          'name': nameController.text,
          'amount': double.parse(amountController.text),
          'accountNumber': accountNumberController.text,
          'phoneNumber': phoneNumberController.text,
          'shortDescription': shortDescriptionController.text,
          'paymentDateTime': now.toIso8601String(),
        };

        if (payerSnapshot.value == null) {
          ref
              .child(user.uid)
              .child('split')
              .child('expensesPayers')
              .push()
              .set(payerData);
        }

        var updatedExpensesAvail =
            currentExpensesAvail - double.parse(amountController.text);

        await ref.child(user.uid).child('split').update({
          'expensesSpendings':
              ServerValue.increment(double.parse(amountController.text)),
          'expensesAvailableBalance': updatedExpensesAvail,
        });

        ref
            .child(user.uid)
            .child('split')
            .child('expensesTransactions')
            .push()
            .set(payerData);

        final payeeData = {...payerData};
        final allTransactionPayer = {
          ...payeeData,
          'amount': '- ${amountController.text}'
        };
        ref
            .child(user.uid)
            .child('split')
            .child('allTransactions')
            .push()
            .set(allTransactionPayer);

        Get.back();
        showSnackBar(text: 'Insufficient Balance', color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.03,
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
                                'Account Pay',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.03,
                          ),
                          CustomeInputs(
                            hintText: 'Full name',
                            icons: Icons.person,
                            textEditingController: nameController,
                            validators: validationsTextContents,
                            textinputTypes: TextInputType.text,
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
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                              hintText: 'Account number',
                              icons: Icons.account_balance,
                              textEditingController: accountNumberController,
                              validators: _validateNumber,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                              hintText: 'Phone number',
                              icons: Icons.call,
                              textEditingController: phoneNumberController,
                              validators: validatingPhoneNumber,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                            hintText: 'Short description',
                            icons: Icons.subject,
                            textEditingController: shortDescriptionController,
                            validators: validationsTextContents,
                            textinputTypes: TextInputType.text,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          CustomeBtn(
                              btnTitleName: const Text("addandpay"),
                              onPress: _addAndPay),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
