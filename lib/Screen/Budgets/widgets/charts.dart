import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gkrd/styles/color.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen(
      {super.key,
      required this.income,
      required this.expenses,
      required this.netamount});
  final double income;
  final double expenses;
  final double netamount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kKarobarcolor,
        elevation: 0,
        title: const Text("charts"),
      ),
      body: SafeArea(
        child: Center(
          child: CaterogizeChart(
            income: income,
            expenses: expenses,
            netamount: netamount,
          ),
        ),
      ),
    );
  }
}

class CaterogizeChart extends StatelessWidget {
  final double income;
  final double expenses;
  final double netamount;

  const CaterogizeChart(
      {super.key,
      required this.income,
      required this.expenses,
      required this.netamount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800, // Adjust the size as needed
      height: 20,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: income,
              color: Colors.green,
              title: 'Need',
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
              title: 'Savings',
              radius: 40,
            ),
          ],
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
