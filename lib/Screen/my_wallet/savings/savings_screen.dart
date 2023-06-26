import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../styles/color.dart';
import '../../widgets/null_errors.dart';
import '../../widgets/transations_card.dart';
import '../widgets/blance_cards.dart';
import 'components/automatic_investment_screen.dart';
import 'components/manual_investment_screen.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
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
                                  horizontal: 18, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BalanceCard(
                                    amount: map['savings'].toStringAsFixed(0),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  const Text(
                                    'Invest',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ManualInvestmentScreen()));
                                        },
                                        child: SavingsCard(
                                          orientation: orientation,
                                          constraints: constraints,
                                          iconName: Icons.trending_up,
                                          title: 'Manual\ninvestment',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AutoInvestmentScreen()));
                                        },
                                        child: Stack(
                                          children: [
                                            SavingsCard(
                                              orientation: orientation,
                                              constraints: constraints,
                                              iconName: Icons.trending_up,
                                              title: 'Automatic\n investment',
                                            ),
                                            Positioned(
                                                left: orientation ==
                                                        Orientation.portrait
                                                    ? 42
                                                    : 125,
                                                top: orientation ==
                                                        Orientation.portrait
                                                    ? 20
                                                    : 12,
                                                child: const Icon(
                                                  Icons.update,
                                                  color: Colors.white,
                                                  size: 22,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  const Text(
                                    'Recent Invesments',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  map['savingInvestments'] == null
                                      ? const Center(
                                          child: Text('No investments'),
                                        )
                                      : StreamBuilder(
                                          stream: ref
                                              .child(user.uid)
                                              .child('split')
                                              .child('savingInvestments')
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
                                                                  '- ${list[index]['amount']}',
                                                              title: list[index]
                                                                  [
                                                                  'companyName'],
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

class SavingsCard extends StatelessWidget {
  const SavingsCard({
    super.key,
    required this.orientation,
    required this.constraints,
    required this.title,
    required this.iconName,
  });

  final Orientation orientation;
  final BoxConstraints constraints;
  final String title;
  final IconData iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 130,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconName,
              color: Colors.white,
              size: 45,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
