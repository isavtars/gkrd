import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../logic/camera_controller.dart';
import '../../../styles/color.dart';
import '../../widgets/custom_cards.dart';
import '../../widgets/null_errors.dart';
import '../../widgets/transations_card.dart';
import '../widgets/blance_cards.dart';
import '../widgets/card_alt.dart';
import 'add_expenses_payer.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: ref.child(user.uid.toString()).child('split').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.snapshot.value == null) {
              return const NullErrorMessage(
                message: 'Something went wrong!',
              );
            } else {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              return Scaffold(
                  body: ChangeNotifierProvider(
                create: (_) => CameraController(),
                child: Consumer<CameraController>(
                    builder: (context, provider, child) {
                  return SafeArea(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return OrientationBuilder(
                          builder:
                              (BuildContext context, Orientation orientation) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //GBalanceCardWallet
                                   GBalanceCardWallet(
                                      amount: map['expensesAvailableBalance']
                                          .toStringAsFixed(0),
                                    ),
                                    SizedBox(
                                      height: constraints.maxHeight * 0.03,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BlanceCard(
                                          color: Colors.red,
                                          height: 80,
                                          width: 150,
                                          cardTitle: 'Income',
                                          cardBalance: map['expenses']
                                              .toStringAsFixed(0),
                                        ),
                                        BlanceCard(
                                          color: Colors.red,
                                          height: 80,
                                          width: 150,
                                          cardTitle: 'Spendings',
                                          cardBalance:
                                              map['expensesSpendings'] == null
                                                  ? 0.toString()
                                                  : map['expensesSpendings']
                                                      .toStringAsFixed(0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: constraints.maxHeight * 0.03,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            provider.pickImage(context);
                                          },
                                          child: CardAlt(
                                            orientation: orientation,
                                            constraints: constraints,
                                            iconName: Icons.qr_code_scanner,
                                            title: 'QR pay',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AddExpensesPayer()));
                                          },
                                          child: CardAlt(
                                            orientation: orientation,
                                            constraints: constraints,
                                            iconName: Icons.account_box,
                                            title: 'Account pay',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: constraints.maxHeight * 0.03,
                                    ),
                                    const Text(
                                      'Expenses Transactions',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: constraints.maxHeight * 0.03,
                                    ),
                                    map['expensesTransactions'] == null
                                        ? const Center(
                                            child: Text(
                                                'No transactions available'),
                                          )
                                        : StreamBuilder(
                                            stream: ref
                                                .child(user.uid)
                                                .child('split')
                                                .child('expensesTransactions')
                                                .onValue,
                                            builder: (context,
                                                AsyncSnapshot<DatabaseEvent>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: kGreenColor,
                                                ));
                                              } else {
                                                Map<dynamic, dynamic> map =
                                                    snapshot.data!.snapshot
                                                        .value as dynamic;
                                                List<dynamic> list = [];
                                                list.clear();
                                                list = map.values.toList();
                                                list.sort((a, b) => b[
                                                        'paymentDateTime']
                                                    .compareTo(
                                                        a['paymentDateTime']));

                                                dynamic formatDate(
                                                    String date) {
                                                  final dynamic newDate =
                                                      DateTime.parse(date);
                                                  final DateFormat formatter =
                                                      DateFormat(
                                                          'E, d MMMM,   hh:mm a');
                                                  final dynamic formatted =
                                                      formatter.format(newDate);
                                                  return formatted;
                                                }

                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: orientation ==
                                                                Orientation
                                                                    .portrait
                                                            ? constraints
                                                                    .maxHeight *
                                                                0.4
                                                            : constraints
                                                                    .maxHeight *
                                                                0.7,
                                                        child: ListView.builder(
                                                            itemCount: snapshot
                                                                .data!
                                                                .snapshot
                                                                .children
                                                                .length,
                                                            itemBuilder:
                                                                ((context,
                                                                    index) {
                                                              return TransationsCards(
                                                                dateTime: formatDate(
                                                                    list[index][
                                                                        'paymentDateTime']),
                                                                amount:
                                                                    '- ${list[index]['amount'].toStringAsFixed(0)}',
                                                                title: list[
                                                                        index]
                                                                    ['name'],
                                                              );
                                                            })),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                    SizedBox(
                                      height: constraints.maxHeight * 0.04,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
              ));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: kGreenColor,
              ),
            );
          }
        });
  }
}
