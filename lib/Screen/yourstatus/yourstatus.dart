import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gkrd/styles/color.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref("Users").child(auth.currentUser!.uid);

class YourStatus extends StatefulWidget {
  const YourStatus({super.key});

  @override
  State<YourStatus> createState() => _YourStatusState();
}

class _YourStatusState extends State<YourStatus> {
  @override
  void initState() {
    super.initState();
    getincomeexpenseData();
  }

  int incomeamount = 100;
  int expenseamount = 210;
  int nettotalamount = 310;

  void getincomeexpenseData() async {
    DatabaseReference incomeRef = ref.child('incexp');
    DataSnapshot snapshot = await incomeRef.get();
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    incomeamount = map['incomeamount'];
    expenseamount = map['expensesamount'];
    nettotalamount = map['netAmounts'];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kKarobarcolor,
        centerTitle: true,
        title: Text("YourStatus",
            style: kJakartaBodyBold.copyWith(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //Income and Expenses status
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: size.width,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 233, 229, 229),
                  offset: Offset(0, 2),
                  blurRadius: 1,
                  spreadRadius: 0.2,
                )
              ]),
              child: Column(children: [
                IncomeExpenseChart(
                  expenses: expenseamount.toDouble(),
                  income: incomeamount.toDouble(),
                  netamount: nettotalamount.toDouble(),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  'Income and Expenses status',
                  style: kJakartaBodyBold.copyWith(
                      fontSize: 18, color: kKarobarcolor),
                ),
              ]),
            ),
            //
          ],
        ),
      ),
    );
  }
}

//
class IncomeExpenseChart extends StatelessWidget {
  final double income;
  final double expenses;
  final double netamount;

  const IncomeExpenseChart(
      {super.key,
      required this.income,
      required this.expenses,
      required this.netamount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600, // Adjust the size as needed
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: income,
              color: Colors.green,
              title: 'Income',
              radius: 40,
            ),
            PieChartSectionData(
              value: expenses,
              color: Colors.red,
              title: 'Expenses',
              radius: 40,
            ),
            PieChartSectionData(
              value: netamount,
              color: Colors.blue,
              title: 'total amount',
              radius: 40,
            ),
          ],
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
