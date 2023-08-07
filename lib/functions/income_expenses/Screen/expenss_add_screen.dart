import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkrd/functions/Reminders/sql/sql_lite_helper.dart';

import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../../Screen/widgets/custom_buttons.dart';
import '../../../Screen/widgets/snackbar.dart';
import '../../../Screen/widgets/tools/dateandtime.dart';
import '../../../styles/color.dart';
import '../../Reminders/widgets/drope_textedits.dart';
import 'incomeexp_screens.dart';
import '../widgets/inc_exp_appbar.dart';

 final FirebaseAuth auth = FirebaseAuth.instance;
 
class ExpensesAdd extends StatefulWidget {
  const ExpensesAdd({super.key});

  @override
  State<ExpensesAdd> createState() => _ExpensesAddState();
}

class _ExpensesAddState extends State<ExpensesAdd> {
  final List<String> expensescaterogy = ["Recharge", "Tax", "Gas", "Petrol"];
  List<String> selectedpayment = ["Cash", "Checeque", "Online"];
  String expensescaterogyvalue = "Selected Caterogies";
  int secectindex = 0;
  var currentdatetime = NepaliDateTime.now();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  bool isFetching = false;

  final ref = FirebaseDatabase.instance.ref("Users").child(auth.currentUser!.uid);

  void addExpenses() async {
    setState(() {
      isFetching = true;
    });
    double? expensesAmount = double.tryParse(amountController.text);

    DatabaseReference incomeRef = ref.child('incexp');
    DataSnapshot snapshot = await incomeRef.get();
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    int incomeamount = map['incomeamount'];
    int expensesamount = map['expensesamount'];
    int netAmounts = map['netAmounts'];

    double newExpAmount = expensesamount + expensesAmount!;
    num totalnetamount = netAmounts - expensesAmount;

    logger.i(
        "thje toalta  l ampont  $incomeamount $expensesamount $totalnetamount ---------------");
    await ref.child('incexp').update({
      "expensesamount": newExpAmount,
      "netAmounts": totalnetamount
    }).then((value) {
      ref.child("incexp").child("addincexp").push().set({
        "selectedCaterogies": expensescaterogyvalue.toString(),
        "amount": ServerValue.increment(newExpAmount),
        "paymentMethod": selectedpayment[secectindex].toString(),
        "note": noteController.text,
        "paymentDateTime": currentdatetime.toIso8601String(),
        "transtype": false
      });
      showSnackBar(text: "Sucessfully add Expensess", color: Colors.green);
    }).onError((err, stackTrace) {
      showSnackBar(text: err.toString(), color: Colors.red);
    });
    setState(() {
      isFetching = true;
    });
    // Get.to(const IncomeExpenses());
   Get.off(() => const IncomeExpenses(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kKarobarcolor,
      appBar: incExpAppBar("Add Expensess"),
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
                    "Expensess Details",
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
                            list: expensescaterogy,
                            value: expensescaterogyvalue,
                            onpress: (String? value) {
                          setState(() {
                            expensescaterogyvalue = value!;
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

                        //dateTime
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
                              addExpenses();
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

//hrloo
