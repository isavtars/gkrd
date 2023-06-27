import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';

import 'package:gkrd/styles/color.dart';
import 'package:gkrd/tools/Reminders/widgets/drope_textedits.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import '../../../Screen/widgets/snackbar.dart';
import '../../../Screen/widgets/tools/dateandtime.dart';

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

  var currentdatetime = NepaliDateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  final reminderController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('Users');

  bool isSelected = false;

//add Reminders
  void addReminders() {
    setState(() {
      isSelected = true;
    });
    ref.child("reminders").set({
      "remindersTypes": remindersvalue,
      "reminderNote": reminderController.text,
      "selectedDate": currentdatetime.toIso8601String(),
      "selectedTime": endTime,
      "remindersTime": remindersTimevalue,
      "status": false
    }).then((value) {
      showSnackBar(text: "Sucessfully add Reminders", color: Colors.green);
    }).onError((err, stackTrace) {
      showSnackBar(text: err.toString(), color: Colors.red);
    });
    setState(() {
      isSelected = false;
    });
    Navigator.pop(context);
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
                        controller: reminderController,
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
                              onTap: () async {
                                NepaliDateTime? _selectedDateTime =
                                    await picker.showMaterialDatePicker(
                                  context: context,
                                  initialDate: NepaliDateTime.now(),
                                  firstDate: NepaliDateTime(2000),
                                  lastDate: NepaliDateTime(2090),
                                  initialDatePickerMode: DatePickerMode.day,
                                );
                                setState(() {
                                  currentdatetime = _selectedDateTime!;
                                });
                              },
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.all(5),
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
                                    width: 2,
                                  ),
                                  Text(
                                      "${dateformater(dateandTime: currentdatetime)}")
                                ]),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                              onTap: () async {
                                getTimeFromUser();
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
                                  Text("$endTime")
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
                              ? CircularProgressIndicator(
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

  Future getTimeFromUser() async {
    var pickedTime = await getTimePicker();
    // ignore: use_build_context_synchronously
    String formateTime = pickedTime.format(context);

    if (pickedTime == null) {
      debugPrint("Time Cancled");
    } else {
      setState(() {
        endTime = formateTime;
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
}
