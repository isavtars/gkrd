import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:intl/intl.dart';

import '../../../styles/color.dart';
import '../../widgets/custom_cards.dart';
import '../../widgets/null_errors.dart';
import '../../widgets/transations_card.dart';
import '../widgets/blance_cards.dart';
import '../widgets/card_alt.dart';
import 'components/add_need_payer.dart';
import 'components/autopay_screen.dart';
import 'components/payers_screen.dart';

class NeedScreen extends StatefulWidget {
  const NeedScreen({super.key});

  @override
  State<NeedScreen> createState() => _NeedScreenState();
}

class _NeedScreenState extends State<NeedScreen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                body: SafeArea(
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
                                    amount: map['needAvailableBalance']
                                        .toStringAsFixed(0),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //BlanceCard
                                      BlanceCard(
                                        color: Colors.red,
                                        height: 80,
                                        width: 150,
                                        cardTitle: 'Income',
                                        cardBalance:
                                            map['need'].toStringAsFixed(0),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      BlanceCard(
                                        color: Colors.red,
                                        height: 80,
                                        width: 150,
                                        cardTitle: 'Spendings',
                                        cardBalance:
                                            map['needSpendings'] == null
                                                ? 0.toString()
                                                : map['needSpendings']
                                                    .toStringAsFixed(0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  CustomeBtn(
                                      btnTitleName: const Text(
                                        '+ New Payment',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      onPress: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddNeedPayer()));
                                      }),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AutopayScreen()));
                                        },
                                        child: CardAlt(
                                          orientation: orientation,
                                          constraints: constraints,
                                          iconName: Icons.schedule,
                                          title: 'Autopays',
                                          
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PayersScreen()));
                                        },
                                        child: CardAlt(
                                          orientation: orientation,
                                          constraints: constraints,
                                          iconName: Icons.groups,
                                          title: 'Payers',
                                         
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  const Text(
                                    'Need Transactions',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  map['needTransactions'] == null
                                      ? const Center(
                                          child:
                                              Text('No transactions available'))
                                      : StreamBuilder(
                                          stream: ref
                                              .child(user.uid)
                                              .child('split')
                                              .child('needTransactions')
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
                                                  snapshot.data!.snapshot.value
                                                      as dynamic;
                                              List<dynamic> list = [];
                                              list.clear();
                                              list = map.values.toList();
                                              list.sort((a, b) => b[
                                                      'paymentDateTime']
                                                  .compareTo(
                                                      a['paymentDateTime']));

                                              dynamic formatDate(String date) {
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
                                                              dateTime:
                                                                  formatDate(list[
                                                                          index]
                                                                      [
                                                                      'paymentDateTime']),
                                                              amount:
                                                                  '- ${list[index]['amount'].toStringAsFixed(0)}',
                                                              title: list[index]
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
                ),
              );
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
