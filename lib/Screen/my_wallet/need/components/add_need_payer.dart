import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/Screen/widgets/custom_inputs.dart';
import 'package:gkrd/Screen/widgets/snackbar.dart';
import 'package:intl/intl.dart';

import '../../../../logic/auto_pay.dart';
import '../../../../styles/color.dart';
import '../../../../styles/gharkharcha_themes.dart';

class AddNeedPayer extends StatefulWidget {
  const AddNeedPayer({super.key});

  @override
  State<AddNeedPayer> createState() => _AddNeedPayerState();
}

class _AddNeedPayerState extends State<AddNeedPayer> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  final user = FirebaseAuth.instance.currentUser!;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final accountNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final shortDescriptionController = TextEditingController();

  bool isAutoPayOn = false;
  DateTime? paymentDateTime;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectedDateTime(BuildContext context) async {
    ThemeData currentTheme = Theme.of(context);

    if (currentTheme.brightness == Brightness.light) {
      currentTheme = GkThemsData.lightTheme;
    } else {
      currentTheme = GkThemsData.darkTheme;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: currentTheme.copyWith(
            dialogBackgroundColor: Theme.of(context).cardColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Theme.of(context).cardColor,
              onSurface: Theme.of(context).primaryColor,
              surface: Theme.of(context).cardColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context).primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final TimeOfDay? pickedTime =
          // ignore: use_build_context_synchronously
          await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return Theme(
            data: currentTheme.copyWith(
              dialogBackgroundColor: Theme.of(context).cardColor,
              colorScheme: ColorScheme.light(
                surface: Theme.of(context).cardColor,
                primary: Theme.of(context).primaryColor,
                onPrimary: Theme.of(context).cardColor,
                onSurface: Theme.of(context).primaryColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).primaryColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(picked.year, picked.month, picked.day,
              pickedTime.hour, pickedTime.minute);
          selectedTime = pickedTime;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

// Validator for name
  String? _validateFormField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

// Validator for numeber realted textfields
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

  void _addAutopay() async {
    if (_formKey.currentState!.validate()) {
      if (isAutoPayOn) {
        DatabaseReference needIncomeRef = ref.child(user.uid).child('split');

        DataSnapshot snapshot = (await needIncomeRef
            .child('needAvailableBalance')
            .get()) as dynamic;

        var currentNeedAvailable = (snapshot.value) as dynamic;

        if (double.parse(amountController.text) > currentNeedAvailable) {
          showSnackBar(text: 'Insufficient Balance', color: Colors.red);
        } else {
          // Check if payer already exists
          DataSnapshot payerSnapshot = await needIncomeRef
              .child('needPayers')
              .orderByChild('accountNumber')
              .equalTo(accountNumberController.text)
              .get() as dynamic;

          final payerData = {
            'name': nameController.text,
            'amount': double.parse(amountController.text),
            'accountNumber': accountNumberController.text,
            'phoneNumber': phoneNumberController.text,
            'shortDescription': shortDescriptionController.text,
            'isAutopayOn': isAutoPayOn,
            'paymentDateTime': selectedDate.toIso8601String(),
          };

          // adding to autopay transaction list
          if (payerSnapshot.value == null) {
            ref
                .child(user.uid)
                .child('split')
                .child('needPayers')
                .push()
                .set(payerData);
          }
          // add transaction to needAutopay
          ref
              .child(user.uid)
              .child('split')
              .child('needAutopay')
              .push()
              .set(payerData)
              .then((value) async {
            Navigator.of(context).pop();
            showSnackBar(text: 'Insufficient Balance', color: Colors.green);

            // Starting autopay method by creating an instance
            Autopay instance = Autopay();
            instance.autoPay();
          }).onError((error, stackTrace) {
            showSnackBar(text: 'Insufficient Balance', color: Colors.red);
          });
        }
      } else {
        showSnackBar(text: 'Insufficient Balance', color: Colors.red);
      }
    }
  }

  void _addAndPay() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference needIncomeRef = ref.child(user.uid).child('split');

      DataSnapshot snapshot =
          (await needIncomeRef.child('needAvailableBalance').get()) as dynamic;

      var currentNeedAvailable = (snapshot.value) as dynamic;

      if (double.parse(amountController.text) > currentNeedAvailable) {
        showSnackBar(text: 'Insufficient Balance', color: Colors.red);
      } else {
        // Check if payer already exists
        DataSnapshot payerSnapshot = await needIncomeRef
            .child('needPayers')
            .orderByChild('accountNumber')
            .equalTo(accountNumberController.text)
            .get() as dynamic;

        // store payer data from textfields
        final payerData = {
          'name': nameController.text,
          'amount': double.parse(amountController.text),
          'accountNumber': accountNumberController.text,
          'phoneNumber': phoneNumberController.text,
          'shortDescription': shortDescriptionController.text,
          'isAutopayOn': isAutoPayOn,
          'paymentDateTime': selectedDate.toIso8601String(),
        };

        // Payer does not exists, add it to payer list
        if (payerSnapshot.value == null) {
          ref
              .child(user.uid)
              .child('split')
              .child('needPayers')
              .push()
              .set(payerData);
        }

        var updatedNeedAvailable =
            currentNeedAvailable - double.parse(amountController.text);

        // Updating balance
        await ref.child(user.uid).child('split').update({
          'needSpendings':
              ServerValue.increment(double.parse(amountController.text)),
          'needAvailableBalance': updatedNeedAvailable,
        });

        // add transaction to needTransactions
        ref
            .child(user.uid)
            .child('split')
            .child('needTransactions')
            .push()
            .set(payerData);

        // add transaction to allTransactions
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

        Navigator.pop(context);
        showSnackBar(text: 'Insufficient Balance', color: Colors.green);
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
                                'Add Payer',
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
                            textinputTypes: TextInputType.text,
                            validators: _validateFormField,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                              hintText: 'Amount',
                              icons: Icons.currency_rupee,
                              textEditingController: amountController,
                              textinputTypes: TextInputType.number,
                              validators: _validateNumber,
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
                              textinputTypes: TextInputType.number,
                              validators: _validateNumber,
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
                              textinputTypes: TextInputType.phone,
                              validators: _validateNumber,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomeInputs(
                            hintText: 'Short description',
                            icons: Icons.subject,
                            validators: null,
                            textinputTypes: TextInputType.text,
                            textEditingController: shortDescriptionController,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Autopay',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Switch(
                                  activeColor: kGreenColor,
                                  value: isAutoPayOn,
                                  onChanged: (value) {
                                    setState(() {
                                      isAutoPayOn = value;
                                    });
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
                          if (isAutoPayOn)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  _selectedDateTime(context);
                                },
                                child: Row(children: [
                                  const Icon(
                                    Icons.date_range,
                                    color: kGrayTextC,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    DateFormat('dd-MM-yyyy  hh:mm a').format(
                                        DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            selectedTime.hour,
                                            selectedTime.minute)),
                                    style: const TextStyle(color: kGrayTextC),
                                  )
                                ]),
                              ),
                            ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          CustomeBtn(
                              btnTitleName: Text('Add Autopa)'),
                              onPress: _addAutopay),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          CustomeBtn(
                              btnTitleName: Text('Add & Pay'),
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
