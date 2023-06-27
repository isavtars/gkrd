import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../styles/color.dart';

import '../../tools/Reminders/all_reminders.dart';
import '../../tools/income_expenses/pages/expenss_screen.dart';
import '../../tools/income_expenses/pages/income_add_screen.dart';
import '../Bugets/buget_home_screen.dart';
import '../my_wallet/wallet_screen.dart';
import '../plan/planning_screen.dart';
import '../widgets/drawer.dart';
import 'Models/front_dosplay_card_model.dart';

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
      // backgroundColor: kKarobarcolor,
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
        return Column(
          children: [
            Container(
                color: kKarobarcolor,
                width: constraints.maxWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                      width: double.maxFinite,
                      child: ListView.builder(
                          itemCount: dispalycarddemo.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return DisplayCards(
                              icons: dispalycarddemo[index].icons,
                              prices: dispalycarddemo[index].prices,
                              cardTitle: dispalycarddemo[index].cardTitle,
                              icconBgColor: dispalycarddemo[index].icconBgColor,
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: kKarobarcolor,
                                      size: 22,
                                    ),
                                    Text(
                                      "Cleander",
                                      style: kJakartaHeading3.copyWith(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(const AllReminders());
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Icon(
                                        Icons.date_range,
                                        color: kKarobarcolor,
                                        size: 22,
                                      ),
                                      Text(
                                        "Reminder",
                                        style: kJakartaHeading3.copyWith(
                                            fontWeight: FontWeight.w600),
                                      )
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                )),

            const SizedBox(
              height: 10,
            ),

            //bodyciontents

            Container(
              width: constraints.maxWidth,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 0.9,
                      child: Image.asset("assets/images/home.png"),
                    )
                  ]),
            )
          ],
        );
      })),
    );
  }
}

class DisplayCards extends StatelessWidget {
  const DisplayCards({
    super.key,
    required this.icons,
    required this.prices,
    required this.cardTitle,
    required this.icconBgColor,
  });

  final IconData icons;
  final String prices;
  final String cardTitle;
  final Color icconBgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.only(right: 10),
      height: 70,
      width: 155,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
            )
          ]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        CircleAvatar(
          backgroundColor: icconBgColor,
          child: Icon(
            icons,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        //
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prices,
              style: kJakartaHeading1.copyWith(
                  fontWeight: FontWeight.w900, fontSize: 15),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              cardTitle,
              style: kJakartaHeading1.copyWith(
                  fontSize: 13, color: Colors.black54),
            )
          ],
        )
      ]),
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
