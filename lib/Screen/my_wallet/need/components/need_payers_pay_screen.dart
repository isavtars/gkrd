import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/Screen/widgets/custom_inputs.dart';

import '../../../../styles/color.dart';
import '../../../widgets/snackbar.dart';

class NeedPayersPayScreen extends StatefulWidget {
  const NeedPayersPayScreen({
    super.key,
    required this.name,
    required this.accountNumber,
  });

  final dynamic name;
  final dynamic accountNumber;

  @override
  State<NeedPayersPayScreen> createState() => _NeedPayersPayScreenState();
}

class _NeedPayersPayScreenState extends State<NeedPayersPayScreen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  var now = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final shortDescriptionController = TextEditingController();

  String? checkValidPercentage(value) {
    if (value.isEmpty) {
      return 'Please enter correct value';
    }
    return null;
  }

  void _addAndPay() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference needAvailRef = ref.child(user.uid).child('split');

      DataSnapshot snapshot =
          (await needAvailRef.child('needAvailableBalance').get()) as dynamic;

      var currentNeedAvail = (snapshot.value) as dynamic;

      final payerData = {
        'name': widget.name,
        'amount': double.parse(amountController.text),
        'accountNumber': widget.accountNumber,
        'shortDescription': shortDescriptionController.text,
        'paymentDateTime': now.toIso8601String(),
      };

      var updatedNeedAvail =
          currentNeedAvail - double.parse(amountController.text);

      await ref.child(user.uid).child('split').update({
        'needSpendings':
            ServerValue.increment(double.parse(amountController.text)),
        'needAvailableBalance': updatedNeedAvail,
      });

      ref
          .child(user.uid)
          .child('split')
          .child('needTransactions')
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
      showSnackBar(text: 'Insufficient Balance', color: Colors.green);
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
                        vertical: 18, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pay Now',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        const Center(
                          child: Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.04,
                        ),
                        const Text(
                          'Payer Name',
                          style: TextStyle(fontSize: 22, color: kGreenColor),
                        ),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        const Text(
                          'Account Number',
                          style: TextStyle(fontSize: 22, color: kGreenColor),
                        ),
                        Text(
                          widget.accountNumber,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        const Text(
                          'Amount',
                          style: TextStyle(fontSize: 22, color: kGreenColor),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Form(
                          key: _formKey,
                          child: CustomeInputs(
                              hintText: 'Enter amount to pay',
                              icons: Icons.currency_rupee,
                              textEditingController: amountController,
                              validators: checkValidPercentage,
                              textinputTypes: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        const Text(
                          'Short description',
                          style: TextStyle(fontSize: 22, color: kGreenColor),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        CustomeInputs(
                          hintText: 'Short description',
                          textinputTypes: TextInputType.text,
                          icons: Icons.subject,
                          textEditingController: shortDescriptionController,
                          validators: checkValidPercentage,
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        CustomeBtn(
                            btnTitleName: const Text('Pay Now'),
                            onPress: _addAndPay)
                      ],
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
