import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkrd/Screen/Dashboard/Screen/dashboard_screen.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';

import '../../styles/color.dart';

import '../widgets/null_errors.dart';
import 'components/add_new_plan_screen.dart';
import 'components/car_planning_screen.dart';
import 'components/emergency_planning_screen.dart';

class PlanningScreeen extends StatefulWidget {
  const PlanningScreeen({super.key});

  @override
  State<PlanningScreeen> createState() => _PlanningScreeenState();
}

class _PlanningScreeenState extends State<PlanningScreeen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  bool isAutoPayOn = false;
  bool isCPenabled = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: ref.child(user.uid.toString()).child('split').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.snapshot.value == null) {
              return const NullErrorMessage(
                message: 'Something went wrong!',
              );
            } else {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

              bool isEFenabled = map['isEFenabled'];
              bool isCPenabled = map['isCPenabled'];
              dynamic targetEmergencyFunds = map['targetEmergencyFunds'];
              dynamic collectedEmergencyFunds = map['collectedEmergencyFunds'];
              dynamic targetCarFunds = map['targetCarFunds'];
              dynamic collectedCarFunds = map['collectedCarFunds'];

              return Scaffold(
                body: SafeArea(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return OrientationBuilder(
                        builder:
                            (BuildContext context, Orientation orientation) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Get.to(const Dashboard());
                                          },
                                          icon: const Icon(Icons.arrow_back)),
                                      const Text(
                                        'Planning',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  const Text(
                                    'Default plans',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  isEFenabled == false
                                      ? Container(
                                          height: orientation ==
                                                  Orientation.portrait
                                              ? constraints.maxHeight * 0.08
                                              : constraints.maxHeight * 0.2,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const EmergencyPlanningScreen()));
                                              },
                                              child: const Text(
                                                'Emergency Funds',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        )
                                      : planningCard(
                                          map,
                                          'Emergency Funds',
                                          map['targetEmergencyFunds']
                                              .toStringAsFixed(0),
                                          map['collectedEmergencyFunds']
                                              .toStringAsFixed(0),
                                          targetEmergencyFunds,
                                          collectedEmergencyFunds),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  isCPenabled == false
                                      ? Container(
                                          height: orientation ==
                                                  Orientation.portrait
                                              ? constraints.maxHeight * 0.08
                                              : constraints.maxHeight * 0.2,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const CarPlanningScreen()));
                                              },
                                              child: const Text(
                                                'Car Plan',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        )
                                      : planningCard(
                                          map,
                                          'Car Plan',
                                          map['targetCarFunds']
                                              .toStringAsFixed(0),
                                          map['collectedCarFunds']
                                              .toStringAsFixed(0),
                                          targetCarFunds,
                                          collectedCarFunds),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  const Text(
                                    'Add plans',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  CustomeBtn(
                                      btnTitleName: const Text(
                                        '+ Add new plan',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      onPress: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddNewPlanScreen()));
                                      }),
                                  SizedBox(
                                    height: orientation == Orientation.portrait
                                        ? constraints.maxHeight * 0.06
                                        : constraints.maxHeight * 0.1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: kGreenColor,
              ),
            );
          }
        });
  }

  Container planningCard(Map<dynamic, dynamic> map, textName, targetFunds,
      collectedFunds, comparetargetFunds, comparecollectedFunds) {
    return Container(
      height: 170,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: kKarobarcolor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textName,
            style: const TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),

          //targetAmount
          Row(
            children: [
              const Text(
                'Target Amount',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "Rs.",
                style: kJakartaBodyBold.copyWith(
                    color: Colors.white, fontSize: 20),
              ),
              Text(
                targetFunds,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          //collected funds
          Row(
            children: [
              const Text(
                'Colllected Funds',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "Rs.",
                style: kJakartaBodyBold.copyWith(
                    color: Colors.white, fontSize: 20),
              ),
              Text(
                collectedFunds,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              appsname,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (comparetargetFunds <= comparecollectedFunds)
            const Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.check_circle,
                size: 90,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

// 