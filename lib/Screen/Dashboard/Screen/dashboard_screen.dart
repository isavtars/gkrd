import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkrd/model/goods_models.dart';

import '../../../styles/color.dart';

import '../../../functions/Reminders/Screens/all_reminder_screen.dart';
import '../../../functions/income_expenses/Screen/expenss_add_screen.dart';
import '../../../functions/income_expenses/Screen/income_add_screen.dart';
import '../../Budgets/budget_home_screen.dart';
import '../../my_wallet/wallet_screen.dart';
import '../../plan/planning_screen.dart';
import '../../Drawer/drawer.dart';

import '../Models/front_dosplay_card_model.dart';
import '../Sql/sqlhelperdgoods.dart';
import 'addgoods_screen.dart';

enum SortOption { latest, nameAZ, nameZA, priceshightwolow, priceslowtohigh }

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
    getItems();
  }

  final dbHelper = SQLHelperGoods();
  final TextEditingController searchController = TextEditingController();
  List<GoodsItem> searchResults = [];
  SortOption selectedSortOption = SortOption.latest;

  void getItems() async {
    final List<GoodsItem> items = await dbHelper.getAllItems();

    // Apply the sorting algorithm based on the selected sort option
    switch (selectedSortOption) {
      case SortOption.latest:
        // No need to sort for the "Latest" option.
        break;
      case SortOption.nameAZ:
        bubbleSortByName(items, ascending: true);
        logger.i(
            ' this is from nameAZ $items iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
        break;
      case SortOption.nameZA:
        bubbleSortByName(items, ascending: false);
        break;
      case SortOption.priceshightwolow:
        bubbleSortByPrice(items, ascending: false);
        break;
      case SortOption.priceslowtohigh:
        bubbleSortByPrice(items, ascending: true);
        break;
    }

    setState(() {
      // searchResults = items;
      searchResults.clear(); // Clear the current list
      searchResults.addAll(items); // Add sorted items to the list
    });
  }

  //deletecode
  void deleteItem(int id) async {
    final dbHelper = SQLHelperGoods();
    await dbHelper.deleteItem(id);

    getItems();
  }

  void handleSearch(String query) async {
    // Perform the search and update the results
    if (query.isEmpty) {
      setState(() {
        getItems();
      });
    } else {
      final results = await dbHelper.searchItems(query);
      //binary search algorithm
      binarySearch(results, results.length.toString());

      setState(() {
        searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kKarobarcolor,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: kKarobarcolor,
        elevation: 0,
        title: const Text("Bibek Bohora"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kKarobarcolor,
        onPressed: () {
          showelevationModels(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              //top header Containers
              toDisplayHeader(constraints),

              const SizedBox(
                height: 10,
              ),

              //bodyciontents

              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: constraints.maxWidth * 0.8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.search,
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: constraints.maxWidth * 0.5,
                          padding: const EdgeInsets.all(2),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "search price by goods",
                                border: InputBorder.none),
                            controller: searchController,
                            onChanged: (query) {
                              // Handle search when the text changes
                              handleSearch(query);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                  IconButton(
                      onPressed: () {
                        sortingdatausingbuttomsheet(context);
                      },
                      icon: const Icon(Icons.sort)),
                ],
              ),

              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(9),
                height: 400,
                child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
                      binarySearch(searchResults, item.name);

                      return GestureDetector(
                        onTap: () {
                          crudbybottomsheet(context, index);
                        },
                        child: GoodsPriceListCards(
                            goodIcons: Icons.abc,
                            goodsTitle: item.name,
                            goodsPrices: item.price.toString(),
                            quantity: item.quantity.toString()),
                      );
                    }),
              ),
            ],
          ),
        );
      })),
    );
  }

  Future<dynamic> sortingdatausingbuttomsheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Sorting data',
                  style: kJakartaBodyBold.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                ListTile(
                  title: const Text('Latest'),
                  leading: Radio(
                    value: SortOption.latest,
                    groupValue: selectedSortOption,
                    onChanged: (value) {
                      setState(() {
                        selectedSortOption = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Name(A-Z)'),
                  leading: Radio(
                    value: SortOption.nameAZ,
                    groupValue: selectedSortOption,
                    onChanged: (value) {
                      setState(() {
                        selectedSortOption = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Name(Z-A)'),
                  leading: Radio(
                    value: SortOption.nameZA,
                    groupValue: selectedSortOption,
                    onChanged: (value) {
                      setState(() {
                        selectedSortOption = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Prices(High-to-low)'),
                  leading: Radio(
                    value: SortOption.priceshightwolow,
                    groupValue: selectedSortOption,
                    onChanged: (value) {
                      setState(() {
                        selectedSortOption = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Prices(low-to-high)'),
                  leading: Radio(
                    value: SortOption.priceslowtohigh,
                    groupValue: selectedSortOption,
                    onChanged: (value) {
                      setState(() {
                        selectedSortOption = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> crudbybottomsheet(BuildContext context, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Delete Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Are you sure you want to delete this item?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    deleteItem(index);
                    Navigator.of(context).pop();
                    getItems();
                  },
                  child: Text('Delete', style: kJakartaBodyBold.copyWith()),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the Bottom Sheet
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Container toDisplayHeader(BoxConstraints constraints) {
    return Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        Get.off(const AllReminders());
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        ));
  }

//Elavitated pop menu
  Future<int?> showelevationModels(BuildContext context) {
    return showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 700, 10, 0),
      items: [
        PopupMenuItem(
          value: 1,
          child: NewPopUPMenu(
            onpressed: () {
              Get.off(const BHomeScreen());
            },
            icons: Icons.home,
            title: "Home",
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: NewPopUPMenu(
            onpressed: () {
              Get.off(const WalletScreen());
            },
            icons: Icons.wallet,
            title: "Wallet",
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: NewPopUPMenu(
            onpressed: () {
              Get.off(const PlanningScreeen());
            },
            icons: Icons.article,
            title: "Planning",
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: NewPopUPMenu(
            onpressed: () {
              Get.off(const IncomeADD());
            },
            icons: Icons.account_balance_wallet,
            title: "Income",
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: NewPopUPMenu(
            onpressed: () {
              Get.off(const ExpensesAdd());
            },
            icons: Icons.account_balance_wallet,
            title: "Expenses",
          ),
        ),
        PopupMenuItem(
          value: 6,
          child: NewPopUPMenu(
            onpressed: () {
              Get.off(const AllReminders());
            },
            icons: Icons.punch_clock,
            title: "Reminders",
          ),
        ),

        PopupMenuItem(
          value: 7,
          child: NewPopUPMenu(
            onpressed: () {
              Get.off(const AddGoodsscreen());
            },
            icons: Icons.add,
            title: "Add goods",
          ),
        ),

        //new Pop
      ],
    );
  }
}

class GoodsPriceListCards extends StatelessWidget {
  const GoodsPriceListCards({
    super.key,
    required this.goodIcons,
    required this.goodsTitle,
    required this.goodsPrices,
    required this.quantity,
  });

  final IconData goodIcons;
  final String goodsTitle;
  final String goodsPrices;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 67, 110, 145),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              radius: 23,
              child: Icon(
                goodIcons,
                size: 25,
                color: Colors.blue,
              )),
          const SizedBox(
            width: 10,
          ),
          Text(
            goodsTitle,
            style: kJakartaBodyBold.copyWith(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 60,
          ),
          Text(
            "Rs",
            style: kJakartaBodyRegular.copyWith(color: Colors.white),
          ),
          const SizedBox(
            width: 2,
          ),
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    goodsPrices,
                    style: kJakartaBodyBold.copyWith(
                        fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 18,
          ),
        ],
      ),
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
