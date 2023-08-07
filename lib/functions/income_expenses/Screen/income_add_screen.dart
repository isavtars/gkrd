import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gkrd/Screen/widgets/snackbar.dart';
import 'package:gkrd/functions/Reminders/sql/sql_lite_helper.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../../Screen/widgets/custom_buttons.dart';
import '../../../Screen/widgets/tools/dateandtime.dart';
import '../../../styles/color.dart';
import '../../Reminders/widgets/drope_textedits.dart';
import 'incomeexp_screens.dart';
import '../widgets/inc_exp_appbar.dart';

class IncomeADD extends StatefulWidget {
  const IncomeADD({super.key});

  @override
  State<IncomeADD> createState() => _IncomeADDState();
}

class _IncomeADDState extends State<IncomeADD> {
  final List<String> incomecaterogy = ["Salary", "Foundes", "Interest"];
  List<String> selectedpayment = ["Cash", "Checeque", "Online"];
  String incomecaterogyvalue = "Selected Caterogies";
  int secectindex = 0;
  var currentdatetime = NepaliDateTime.now();

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref("Users");
  bool isFetching = false;

  //add data

  @override
  void initState() {
    super.initState();
  }

  void addIncome() async {
    setState(() {
      isFetching = true;
    });
    double? incomeAmount = double.tryParse(amountController.text);

    DatabaseReference incomeRef = ref.child('incexp');
    DataSnapshot snapshot = await incomeRef.get();
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    int incomeamount = map['incomeamount'];
    int expensesamount = map['expensesamount'];
    int netAmounts = map['netAmounts'];

    double newAmount = incomeamount + incomeAmount!;
    num totalnetamount = netAmounts + incomeAmount;

    logger.i("$incomeamount $expensesamount $totalnetamount");

    await ref
        .child('incexp')
        .update({"incomeamount": newAmount, "netAmounts": totalnetamount}).then(
            (value) {
      ref.child("incexp").child("addincexp").push().set({
        "selectedCaterogies": incomecaterogyvalue.toString(),
        "amount": ServerValue.increment(newAmount),
        "paymentMethod": selectedpayment[secectindex].toString(),
        "note": noteController.text,
        "paymentDateTime": currentdatetime.toIso8601String(),
        "transtype": true
      });
      showSnackBar(text: "Sucessfully add Income", color: Colors.green);
    }).onError((err, stackTrace) {
      showSnackBar(text: err.toString(), color: Colors.red);
    });
    setState(() {
      isFetching = true;
    });

    Get.off(() => const IncomeExpenses(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kKarobarcolor,
      appBar: incExpAppBar("Add Income"),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            width: constraints.maxWidth,
            // padding: const EdgeInsets.symmetric(horizontal: 17),
            color: const Color.fromARGB(255, 240, 238, 238),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  child: Text(
                    "Income Details",
                    style: kJakartaHeading1.copyWith(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                //detailscontainers
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  width: constraints.maxWidth,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Categories",
                          style: kJakartaHeading1.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        dropedowncont(constraints,
                            list: incomecaterogy, value: incomecaterogyvalue,
                            onpress: (String? value) {
                          setState(() {
                            incomecaterogyvalue = value!;
                          });
                        }),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Amount",
                          style: kJakartaHeading1.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //amount
                        Container(
                          width: constraints.maxWidth,
                          height: 56,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color.fromARGB(255, 240, 238, 238)),
                          child: TextFormField(
                            controller: amountController,
                            decoration: const InputDecoration(
                              hintText: "Rs.",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        //paymentMethods
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Payments Methods",
                          style: kJakartaHeading1.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        Wrap(
                          children: List.generate(3, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  secectindex = index;
                                  logger.i("$secectindex ");
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 85,
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: secectindex == index
                                        ? kKarobarcolor
                                        : const Color.fromARGB(
                                            255, 240, 238, 238),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Center(
                                    child: Text(
                                  selectedpayment[index],
                                  style: kJakartaHeading3.copyWith(
                                      color: secectindex == index
                                          ? Colors.white
                                          : Colors.black),
                                )),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Note",
                          style: kJakartaHeading1.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //Note
                        Container(
                          width: constraints.maxWidth,
                          height: 56,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color.fromARGB(255, 240, 238, 238)),
                          child: TextFormField(
                            controller: noteController,
                            decoration: const InputDecoration(
                              hintText: "Note",
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
                          "Date",
                          style: kJakartaHeading1.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        GestureDetector(
                            onTap: () async {
                              NepaliDateTime? selectedDateTime =
                                  await picker.showMaterialDatePicker(
                                context: context,
                                initialDate: NepaliDateTime.now(),
                                firstDate: NepaliDateTime(2000),
                                lastDate: NepaliDateTime(2090),
                                initialDatePickerMode: DatePickerMode.day,
                              );
                              setState(() {
                                currentdatetime = selectedDateTime!;
                              });
                            },
                            child: Container(
                              width: constraints.maxWidth * .5,
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
                                Text(
                                    "${dateformater(dateandTime: currentdatetime)}")
                              ]),
                            )),

                        const SizedBox(
                          height: 20,
                        ),

                        CustomeBtn(
                            btnTitleName: isFetching
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                            onPress: () {
                              addIncome();
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                )
              ],
            ),
          ),
        );
      })),
    );
  }
}
