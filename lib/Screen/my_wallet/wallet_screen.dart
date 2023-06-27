import 'package:flutter/material.dart';

import '../../styles/color.dart';
import 'expenses/expenses_screen.dart';
import 'need/need_screen.dart';
import 'savings/savings_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.03,
                      ),
                      Row(children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 29,
                          ),
                        ),
                        Text(
                          "My Wallets",
                          style: kJakartaBodyBold.copyWith(
                              color: kKarobarcolor, fontSize: 22),
                        )
                      ]),
                      SizedBox(
                        height: constraints.maxHeight * 0.005,
                      ),
                      Container(
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: kGreenColor,
                          controller: _tabController,
                          unselectedLabelColor: kGrayTextC,
                          indicatorColor: kGreenColor,
                          tabs: const [
                            Tab(text: 'Need'),
                            Tab(text: 'Expenses'),
                            Tab(text: 'Savings'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            NeedScreen(),
                            ExpensesScreen(),
                            SavingsScreen(),
                          ],
                        ),
                      ),
                    ],
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
