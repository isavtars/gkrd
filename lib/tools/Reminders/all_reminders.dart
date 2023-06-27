import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../styles/color.dart';
import 'Screens/add_screen.dart';

class AllReminders extends StatefulWidget {
  const AllReminders({super.key});

  @override
  State<AllReminders> createState() => _AllRemindersState();
}

class _AllRemindersState extends State<AllReminders>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<String> cateroigtype = ["Income", "Expenses"];
  String cateroigtypevalue = "Selected type";

  final ref = FirebaseDatabase.instance.ref('Users').child('reminders');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  final caterogiesname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kKarobarcolor,
          onPressed: () {
            Get.to(const AddReminderScreens());
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kKarobarcolor,
          title: Text(
            "All  Reminders",
            style: kJakartaHeading3.copyWith(
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                // text: 'Income',
                child: Text(
                  "UpComming",
                  style: kJakartaBodyBold.copyWith(
                      fontSize: 16,
                      color: _currentIndex == 0
                          ? Colors.white
                          : const Color.fromARGB(255, 228, 226, 226)),
                ),
              ),
              Tab(
                child: Text(
                  "Completed",
                  style: kJakartaBodyBold.copyWith(
                      fontSize: 16,
                      color: _currentIndex == 1
                          ? Colors.white
                          : const Color.fromARGB(255, 228, 226, 226)),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              FirebaseAnimatedList(
                query: ref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return Container(
                    child: Row(
                      children: [
                        Text('${snapshot.value is bool ? snapshot.value : ''}'),
                        Text(
                            '${snapshot.value is String ? snapshot.value : ''}'),
                      ],
                    ),
                  );
                },
              ),

              // Content for Tab 2
              Center(child: Text('Tab 2 Content $_currentIndex ')),
            ],
          ),
        ));
  }
}
