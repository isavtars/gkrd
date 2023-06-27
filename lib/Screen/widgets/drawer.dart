import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/drawer_entry.dart';
import '../../styles/color.dart';
import '../../tools/emi_calculator.dart';
import '../../tools/income_expenses/incomeexp.dart';
import '../Bugets/buget_home_screen.dart';
import '../auth/login.dart';
import '../my_wallet/wallet_screen.dart';
import '../plan/planning_screen.dart';

import '../userprofile/user_profile.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

@override
void initState() {}

DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

final user = FirebaseAuth.instance.currentUser!;

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                  stream: ref.child(user.uid.toString()).onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<dynamic, dynamic>? map = snapshot.data?.snapshot.value
                          as Map<dynamic, dynamic>;
                      return UserAccountsDrawerHeader(
                        accountName: Text(
                          map['fullName'],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        accountEmail: Text(
                          map['email'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        decoration: const BoxDecoration(color: kKarobarcolor),
                        currentAccountPicture: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(map['profilePic']),
                          ),
                        ),
                      );
                    } else {
                      return const UserAccountsDrawerHeader(
                        accountName: Text(
                          "Bibek chhetri",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        accountEmail: Text(
                          "Email.class",
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(color: kKarobarcolor),
                        currentAccountPicture: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: kKarobarcolor,
                            // backgroundImage: NetworkImage(photoImages),
                          ),
                        ),
                      );
                    }
                  }),

              ListTile(
                leading: const Icon(
                  Icons.business,
                  color: kGreenColor,
                ),
                title: const Text('Your Status'),
                onTap: () {},
              ),
              const SizedBox(
                height: 5,
              ),
              const TitleWithDrawer(
                title: "MANAGEMENT",
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: kGreenColor,
                ),
                title: const Text('Home'),
                onTap: () {
                  Get.to(const BHomeScreen());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: kGreenColor,
                ),
                title: const Text('Wallet'),
                onTap: () {
                  Get.to(const WalletScreen());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.article,
                  color: kKarobarcolor,
                ),
                title: const Text('Planning'),
                onTap: () {
                  Get.to(const PlanningScreeen());
                },
              ),

              //calculatedemi
              ListTile(
                leading: const Icon(
                  Icons.calculate,
                  color: kKarobarcolor,
                ),
                title: const Text('Calculate EMI'),
                onTap: () {
                  Get.to(const EMICalculator());
                },
              ),

              //cash at bank
              ListTile(
                leading: const Icon(
                  Icons.wallet,
                  color: kKarobarcolor,
                ),
                title: EntryItem(dataforcash.first),
              ),

              //incomeexp
              ListTile(
                leading: const Icon(
                  Icons.wallet,
                  color: kGreenColor,
                ),
                title: const Text('Income/Expenses'),
                onTap: () {
                  Get.to(const IncomeExpenses());
                },
              ),
              const SizedBox(
                height: 5,
              ),

              const TitleWithDrawer(
                title: "HELP & SUPPORT",
              ),
              ListTile(
                leading: const Icon(
                  Icons.announcement,
                  color: kGreenColor,
                ),
                title: const Text('Notices'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.contact_emergency,
                  color: kGreenColor,
                ),
                title: const Text('Contact us'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.help,
                  color: kGreenColor,
                ),
                title: const Text('Learn to use'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.star,
                  color: kGreenColor,
                ),
                title: const Text('Rate this app'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: kGreenColor,
                ),
                title: const Text('Share this app'),
                onTap: () {},
              ),
              const SizedBox(
                height: 5,
              ),
              const TitleWithDrawer(
                title: "SYSTEM",
              ),
              //logout

              //profile
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: kGreenColor,
                ),
                title: const Text('Profile'),
                onTap: () {
                  Get.to(const UserProfile());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: kGreenColor,
                ),
                title: const Text('All Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleWithDrawer extends StatelessWidget {
  const TitleWithDrawer({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(
              title,
              style: kJakartaBodyBold.copyWith(
                  fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider()
        ]);
  }
}

//for the
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, {super.key});

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      iconColor: kKarobarcolor,
      textColor: kKarobarcolor,
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  Navigator.pop(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: kKarobarcolor),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              // Perform logout operation here
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
