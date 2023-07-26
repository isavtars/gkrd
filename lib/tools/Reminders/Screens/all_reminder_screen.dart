import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/logic/reminder_task_controller.dart';
import 'package:gkrd/tools/Reminders/models/task_models.dart';
import 'package:gkrd/tools/Reminders/notifications/notifications_hepler.dart';
import 'package:gkrd/tools/Reminders/sql/sql_lite_helper.dart';
import 'package:gkrd/tools/Reminders/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

import '../../../styles/color.dart';
import 'add_screen.dart';

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
    getsTask();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  final caterogiesname = TextEditingController();
  final _taskController = Get.find<TaskController>();
  getsTask() async {
    await _taskController.getTasks();
  }

  final notifiHelper = NotificationHelper();
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
              // upcoming reminder
              Obx(() {
                return ListView.builder(
                    itemCount: _taskController.taskList.length,
                    itemBuilder: (context, index) {
                      logger.i(
                          "${_taskController.taskList.length.toString()} kkkkss");

                      ReminderTask tasked = _taskController.taskList[index];
                      logger.i('${tasked.toJson()}');
                      logger.i("Start Time: ${tasked.startTime}");

                      DateTime mydate = DateFormat.jm()
                          .parse(tasked.startTime.toString().trim());

                      var myTime = DateFormat("hh:mm").format(mydate);
                      notifiHelper.scheduledNotification(
                          int.parse(myTime.toString().split(":")[0]),
                          int.parse(myTime.toString().split(":")[1]),
                          tasked);

                      logger.i(myTime);

                      notifiHelper.displayNotfications(
                          title: "heloo ", body: "heloo santosh");

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                bottomsheet(context, index);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black54,
                                          spreadRadius: 1,
                                          offset: Offset(5, 3),
                                          blurRadius: 7)
                                    ],
                                    color: Color.fromARGB(255, 214, 226, 235),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: const EdgeInsets.all(7),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Row(
                                  children: [
                                    //left
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _taskController
                                                .taskList[index].title
                                                .toString(),
                                            style: kJakartaBodyMedium.copyWith(
                                                color: kKarobarcolor,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.access_time_rounded,
                                                size: 18,
                                                color: Color.fromARGB(
                                                    255, 3, 41, 53),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                _taskController
                                                    .taskList[index].startTime
                                                    .toString(),
                                                style:
                                                    kJakartaBodyMedium.copyWith(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 3, 41, 53),
                                                        fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              _taskController
                                                  .taskList[index].note
                                                  .toString(),
                                              style:
                                                  kJakartaBodyMedium
                                                      .copyWith(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 3, 41, 53),
                                                          fontSize: 17)),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 50,
                                      child: Divider(
                                        height: 10,
                                      ),
                                    ),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                          " ${_taskController.taskList[index].isComplited == 1 ? "Completed" : "Todo"}",
                                          style: kJakartaBodyMedium.copyWith(
                                            fontSize: 16,
                                            color: _taskController
                                                        .taskList[index]
                                                        .isComplited ==
                                                    1
                                                ? Colors.green
                                                : Colors.red,
                                          )),
                                    )
                                  ],
                                  //right
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }),

              // Content for Tab 2
              Center(child: Text('Tab 2 Content $_currentIndex ')),
            ],
          ),
        ));
  }

// bottomsheet
  PersistentBottomSheetController<dynamic> bottomsheet(
      BuildContext context, int index) {
    return showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.all(20),
              height: 330,
              width: double.infinity,
              child: Column(
                children: [
                  _taskController.taskList[index].isComplited == 1
                      ? Container()
                      : CustomeBtn(
                          btnTitleName: const Text("Task Completed"),
                          onPress: () {
                            _taskController.makeTaskCompleted(
                                _taskController.taskList[index].id!);
                            _taskController.getTasks();
                            Get.back();
                          }),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomeBtn(
                    btnTitleName: const Text("Delete"),
                    onPress: () {
                      // Show a confirmation dialog before deleting the task
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text(
                                "Are you sure you want to delete this task?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel",
                                    style: TextStyle(color: Colors.green)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // Delete the task and close the dialog
                                  _taskController.deleteTask(
                                      _taskController.taskList[index]);
                                  _taskController.getTasks();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  // Show a snackbar to inform the user that the task has been deleted successfully
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: CustomSnackBar(
                                          text: "Task deleted successfully"),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomeBtn(
                      btnTitleName: const Text("Update"),
                      onPress: () {
                        Get.to(const AddReminderScreens());
                        // _taskController.getTasks();
                        // Navigator.pop(context);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomeBtn(
                      btnTitleName: const Text("close"),
                      onPress: () {
                        _taskController.getTasks();
                        Navigator.pop(context);
                      })
                ],
              ));
        });
  }
}
