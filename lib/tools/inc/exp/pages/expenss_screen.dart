import 'package:flutter/material.dart';


import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../../../Screen/widgets/custom_buttons.dart';
import '../../../../Screen/widgets/tools/dateandtime.dart';
import '../../../../styles/color.dart';
import '../widgets/inc_exp_appbar.dart';

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
                        dropedowncont(constraints),
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
                                  print("$secectindex ");
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
                            btnTitleName: const Text(
                              "Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPress: () {}),
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

  Container dropedowncont(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: 56,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color.fromARGB(255, 240, 238, 238)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            expensescaterogyvalue,
            style: kJakartaHeading3.copyWith(fontSize: 15, color: Colors.grey),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              onChanged: (value) {
                setState(() {
                  expensescaterogyvalue = value!;
                });
              },
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 0,
              style: const TextStyle(fontSize: 19, color: kGreenColor),
              items: expensescaterogy
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: kJakartaHeading3.copyWith(
                        fontSize: 15, color: kKarobarcolor),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

//hrloo
