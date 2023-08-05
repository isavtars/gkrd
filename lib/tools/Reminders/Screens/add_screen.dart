import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/Screen/widgets/snackbar.dart';
import 'package:gkrd/logic/reminder_task_controller.dart';

import 'package:gkrd/styles/color.dart';
import 'package:gkrd/tools/Reminders/Screens/all_reminder_screen.dart';
import 'package:gkrd/tools/Reminders/models/task_models.dart';
import 'package:gkrd/tools/Reminders/sql/sql_lite_helper.dart';
import 'package:gkrd/tools/Reminders/widgets/drope_textedits.dart';
import 'package:intl/intl.dart';



class AddReminderScreens extends StatefulWidget {
  const AddReminderScreens({super.key});

  @override
  State<AddReminderScreens> createState() => _AddReminderScreensState();
}

class _AddReminderScreensState extends State<AddReminderScreens> {
  final List<String> remindersTypes = ["Payments", "Alerts", "AlertPayment"];
  String remindersvalue = "Selected type";

  final List<String> remindersTimes = ["Daily", "Weekly", "Monthly"];
  String remindersTimevalue = "Selected The Time";


   DateTime _selectedDate = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  final noteController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('Users');

  bool isSelected = false;
  final _taskController = Get.find<TaskController>();

//add Reminders
  void addReminders() async {
    if (noteController.text.isNotEmpty) {
      int value = await _taskController.addToTask(
          task: ReminderTask(
        title: remindersvalue,
        note: noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: startTime,
        reminder: remindersTimevalue,
        isComplited: 0,
      ));

      logger
          .d("'---------------------- $value --------------------------------");

      Get.to(const AllReminders());
      showSnackBar(text: 'Reminder added successfully', color: Colors.green);
    } else {
      Get.snackbar("Required all the feilds", "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: kKarobarcolor,
            title: const Text("Add Reminders")),
        backgroundColor: kKarobarcolor,
        body: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Reminder Type",
                      style: kJakartaBodyBold.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //dropedownsforpaymentreminders
                    dropedowncont(constraints,
                        value: remindersvalue,
                        list: remindersTypes, onpress: (String? value) {
                      setState(() {
                        remindersvalue = value!;
                      });
                    }),

                    const SizedBox(
                      height: 15,
                    ),

                    Text(
                      "Reminders",
                      style: kJakartaBodyBold.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      width: constraints.maxWidth,
                      // height: 86,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Color.fromARGB(255, 240, 238, 238)),
                      child: TextFormField(
                        controller: noteController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Selected Date and Time",
                      style: kJakartaBodyBold.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //startrime/endtime
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: userDatePicker,
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Color.fromARGB(255, 240, 238, 238)),
                                child:  Row(children: [
                                  const Icon(
                                    Icons.date_range,
                                    color: kKarobarcolor,
                                  ),
                                 const  SizedBox(
                                    width: 2,
                                  ),
                                  Text( DateFormat.yMd().format(_selectedDate))
                                ]),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                              onTap: () async {
                                getTimeFromUser(isStartTime: true);
                              },
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Color.fromARGB(255, 240, 238, 238)),
                                child: Row(children: [
                                  const Icon(
                                    Icons.date_range,
                                    color: kKarobarcolor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(startTime)
                                ]),
                              )),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Reminder Times",
                      style: kJakartaBodyBold.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //dropedownsforpaymentreminders
                    dropedowncont(constraints,
                        value: remindersTimevalue,
                        list: remindersTimes, onpress: (String? value) {
                      setState(() {
                        remindersTimevalue = value!;
                      });
                    }),
                    const SizedBox(
                      height: 40,
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomeBtn(
                          btnTitleName: isSelected
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Save",
                                  style: kJakartaHeading1.copyWith(
                                      color: Colors.white),
                                ),
                          onPress: addReminders),
                    ),

                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ));
          }),
        ));
  }

  Future getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await getTimePicker();

    // ignore: use_build_context_synchronously
    String formateTime = pickedTime.format(context);

    if (pickedTime == null) {
      logger.d("Time Cancled");
    } else if (isStartTime == true) {
      setState(() {
        startTime = formateTime;
        logger.d(startTime);
      });
    }
  }

  getTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        // initialTime: selectedTime
        initialTime: TimeOfDay(
            hour: int.parse(startTime.split(':')[0]),
            minute: int.parse(startTime.split(':')[1].split(" ")[0])));
  }

  userDatePicker() async {
    DateTime? pickerDate = await showDatePicker(
      // currentDate: DateTime.now(),

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2121),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      logger.d("erroer somthings");
    }
  }
}
