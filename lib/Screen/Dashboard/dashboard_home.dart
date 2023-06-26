import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../styles/color.dart';
import '../../tools/inc/exp/pages/expenss_screen.dart';
import '../../tools/inc/exp/pages/income_add_screen.dart';
import '../Bugets/buget_home_screen.dart';
import '../my_wallet/wallet_screen.dart';
import '../plan/planning_screen.dart';
import '../widgets/drawer.dart';

//homepage/dashboard
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kKarobarcolor,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: kKarobarcolor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kKarobarcolor,
        onPressed: () {
          showMenu(
            context: context,
            position: const RelativeRect.fromLTRB(100, 700, 10, 0),
            items: [
              PopupMenuItem(
                value: 1,
                child: NewPopUPMenu(
                  onpressed: () {
                    Get.to(const BHomeScreen());
                  },
                  icons: Icons.home,
                  title: "Home",
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: NewPopUPMenu(
                  onpressed: () {
                    Get.to(const WalletScreen());
                  },
                  icons: Icons.wallet,
                  title: "Wallet",
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: NewPopUPMenu(
                  onpressed: () {
                    Get.to(const PlanningScreeen());
                  },
                  icons: Icons.article,
                  title: "Planning",
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: NewPopUPMenu(
                  onpressed: () {
                    Get.to(const IncomeADD());
                  },
                  icons: Icons.account_balance_wallet,
                  title: "Income",
                ),
              ),
              PopupMenuItem(
                value: 5,
                child: NewPopUPMenu(
                  onpressed: () {
                    Get.to(const ExpensesAdd());
                  },
                  icons: Icons.account_balance_wallet,
                  title: "Expenses",
                ),
              ),
            ],
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return Container(
            color: Colors.white,
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: kKarobarcolor,
                  child: const Text("Reminder"),
                )
              ],
            ));
      })),
    );
  }
}

class NewPopUPMenu extends StatelessWidget {
  const NewPopUPMenu({
    super.key,
    required this.icons,
    required this.title,
    required this.onpressed,
  });

  final IconData icons;
  final String title;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white10,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 110, 197, 161),
                child: Icon(icons, color: Colors.white),
              ),
              const SizedBox(
                width: 17,
              ),
              SizedBox(
                width: 80,
                child: Text(
                  title,
                  style: kJakartaHeading1.copyWith(fontSize: 16),
                ),
              )
            ],
          )),
    );
  }
}
