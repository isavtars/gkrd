import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';

import '../../../Budgets/budget_home_screen.dart';
import '../../../widgets/snackbar.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({
    super.key,
    required this.companyName,
    required this.investmentAmount,
  });

  final dynamic companyName;
  final dynamic investmentAmount;

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  double currentValue = 0;

  final DatabaseReference stocksRef =
      FirebaseDatabase.instance.ref().child('stocks');
  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  var now = DateTime.now();

  void invest() async {
    DatabaseReference savingsRef = ref.child(user.uid).child('split');

    DataSnapshot snapshot =
        (await savingsRef.child('savings').get()) as dynamic;

    var currentSavings = (snapshot.value) as dynamic;

    if (currentSavings < double.parse(widget.investmentAmount)) {
      showSnackBar(
          text: 'Please select number of years & risk capacity',
          color: Colors.green);
    } else if (currentSavings >= double.parse(widget.investmentAmount)) {
      var updatedSavings =
          currentSavings - double.parse(widget.investmentAmount);

      final payerData = {
        'companyName': widget.companyName,
        'amount': double.parse(widget.investmentAmount),
        'paymentDateTime': now.toIso8601String(),
      };
      ref
          .child(user.uid)
          .child('split')
          .child('savingInvestments')
          .push()
          .set(payerData);

      await ref.child(user.uid).child('split').update({
        'savings': updatedSavings,
      });

      final allTransactionsPayer = {
        'name': widget.companyName,
        'amount': '- ${widget.investmentAmount}',
        'paymentDateTime': now.toIso8601String(),
      };
      ref
          .child(user.uid)
          .child('split')
          .child('allTransactions')
          .push()
          .set(allTransactionsPayer);

      showSnackBar(
          text: 'Please select number of years & risk capacity',
          color: Colors.green);

      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => const BHomeScreen()));
    } else {
      showSnackBar(
          text: 'Please select number of years & risk capacity',
          color: Colors.red);
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
                              'Invest',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        const Center(
                          child: Text(
                            'Investment Details',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.04,
                        ),
                        Text(
                          'Company name',
                          style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          widget.companyName,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Text(
                          'Amount',
                          style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          widget.investmentAmount,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        CustomeBtn(
                           
                            btnTitleName:const Text('Invest'),
                            onPress: invest)
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
