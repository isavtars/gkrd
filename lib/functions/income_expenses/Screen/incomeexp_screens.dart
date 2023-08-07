import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Screen/Budgets/budget_home_screen.dart';
import '../../../styles/color.dart';

import '../../Reminders/widgets/drope_textedits.dart';
import 'add_incexp_caterogies.dart';
import 'expenss_add_screen.dart';
import 'income_add_screen.dart';
 final FirebaseAuth auth = FirebaseAuth.instance;
class IncomeExpenses extends StatefulWidget {
  const IncomeExpenses({super.key});

  @override
  State<IncomeExpenses> createState() => _IncomeExpensesState();
}

class _IncomeExpensesState extends State<IncomeExpenses> {
  List<String> dropedownmenu = ["Day", "Month", "Years"];

  String dropeablevalue = "Day";

  DatabaseReference sref = FirebaseDatabase.instance.ref().child('Users').child(auth.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      backgroundColor: kKarobarcolor,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: StreamBuilder(
              stream: sref.child('incexp').onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("uroffline"),
                  );
                } else {
                  Map<dynamic, dynamic>? map =
                      snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                  return Container(
                    color: kKarobarcolor,
                    child: Column(children: [
                      //displaycontainer
                      displaycontener(constraints, map),

                      const SizedBox(
                        height: 8,
                      ),

                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //filtterRow
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  dropedowncontmini(constraints,
                                      list: dropedownmenu,
                                      value: dropeablevalue,
                                      onpress: (String? value) {
                                    setState(() {
                                      dropeablevalue = value!;
                                    });
                                  }),
                                  const Text("SelectedDate and Years ")
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              Text(
                                "All Income & Expenses",
                                style: kJakartaHeading3.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              map['addincexp'] == null
                                  ? AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.asset(
                                          "assets/images/addTrans.png"))
                                  : StreamBuilder(
                                      stream: sref
                                          .child('incexp')
                                          .child('addincexp')
                                          .onValue,
                                      builder: (context,
                                          AsyncSnapshot<DatabaseEvent>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ));
                                        } else {
                                          Map<dynamic, dynamic> map = snapshot
                                              .data!.snapshot.value as dynamic;
                                          List<dynamic> list = [];
                                          list.clear();
                                          list = map.values.toList();
                                          list.sort((a, b) =>
                                              b['paymentDateTime'].compareTo(
                                                  a['paymentDateTime']));

                                          return Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                    height:
                                                        constraints.maxHeight *
                                                            0.5,
                                                    child: ListView.builder(
                                                        itemCount: snapshot
                                                            .data!
                                                            .snapshot
                                                            .children
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return IncExpTransCard(
                                                              title: list[index]
                                                                  [
                                                                  'selectedCaterogies'],
                                                              note: list[index]
                                                                  ['note'],
                                                              prices: list[
                                                                          index]
                                                                      ['amount']
                                                                  .toString(),
                                                              transtype: list[
                                                                      index]
                                                                  ['transtype'],
                                                              paymentDate:
                                                                  formatDate(
                                                                list[index][
                                                                    'paymentDateTime'],
                                                              ));
                                                        })),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),

                              const SizedBox(
                                height: 15,
                              ),
                            ]),
                      )
                    ]),
                  );
                }
              }),
        );
      })),
      bottomSheet: const BottomSheet(),
    );
  }

  Container displaycontener(
      BoxConstraints constraints, Map<dynamic, dynamic>? map) {
    return Container(
      height: constraints.maxHeight * 0.13,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prices(prices: "${map!['incomeamount']}"),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  "Income",
                  style: kJakartaBodyMedium.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prices(prices: "${map['expensesamount']}", isExpenses: true),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  "Expensess",
                  style: kJakartaBodyMedium.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prices(prices: "${map['netAmounts']}"),
                const SizedBox(
                  height: 3,
                ),
                Text("Net amount",
                    style: kJakartaBodyMedium.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w500))
              ],
            )
          ]),
    );
  }

  AppBar appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: kKarobarcolor,
      title: Text(
        "Income Expenses",
        style: kJakartaHeading3.copyWith(
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.to(const AddCaterogy());
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.white)),
              child: Text(
                "Categories",
                style: kJakartaBodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )),
        )
      ],
    );
  }

  Row prices({required String prices, bool isExpenses = false}) {
    return Row(
      children: [
        Text(
          "Rs.",
          style: kJakartaBodyMedium.copyWith(
              color: isExpenses ? Colors.red : kKarobarcolor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        Text(
          prices,
          style: kJakartaBodyMedium.copyWith(
              color: isExpenses ? Colors.red : kKarobarcolor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class IncExpTransCard extends StatelessWidget {
  const IncExpTransCard({
    super.key,
    required this.title,
    required this.note,
    required this.paymentDate,
    required this.prices,
    required this.transtype,
  });

  final String title, note, paymentDate, prices;
  final bool transtype;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 235, 234, 234),
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(0, 3),
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: kJakartaBodyBold.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              note,
              style: kJakartaBodyBold.copyWith(
                  fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              paymentDate,
              style: kJakartaBodyBold.copyWith(
                  fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        Text(
          "Rs:$prices",
          style: kJakartaBodyBold.copyWith(
              fontSize: 14,
              color: transtype == true ? Colors.green : Colors.red),
        )
      ]),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //income
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const IncomeADD()));
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 50,
            width: 150,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: kKarobarcolor),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                "Income",
                style: kjakartaHeading2.copyWith(
                    fontSize: 14, color: Colors.white),
              )
            ]),
          ),
        ),

        const SizedBox(
          width: 20,
        ),
        //expenses
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ExpensesAdd()));
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 50,
            width: 150,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color.fromARGB(255, 218, 50, 38)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.remove,
                color: Colors.white,
              ),
              Text(
                "Expencess",
                style: kjakartaHeading2.copyWith(
                    fontSize: 14, color: Colors.white),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
