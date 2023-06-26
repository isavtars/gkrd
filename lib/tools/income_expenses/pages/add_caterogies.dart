import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



import '../../../Screen/widgets/custom_buttons.dart';
import '../../../styles/color.dart';
import '../resources/add_caterogies_resources.dart';

class AddCaterogy extends StatefulWidget {
  const AddCaterogy({super.key});

  @override
  State<AddCaterogy> createState() => _AddCaterogyState();
}

class _AddCaterogyState extends State<AddCaterogy>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<String> cateroigtype = ["Income", "Expenses"];
  String cateroigtypevalue = "Selected type";

  final caterogiesname = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    getData();
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  getData() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    DocumentSnapshot snap =
        await _firestore.collection("caterogies").doc('5467').get();

    var map = snap.data() as Map<String, dynamic>;

    String categoryType = map['categoryType'];
    String categoryName = map['categoryName'];

    print(" the categoryType name is $categoryType $categoryName");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kKarobarcolor,
          title: Text(
            "Income Expenses",
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
                  "Income",
                  style: kJakartaBodyBold.copyWith(
                      fontSize: 16,
                      color: _currentIndex == 0
                          ? Colors.white
                          : const Color.fromARGB(255, 228, 226, 226)),
                ),
              ),
              Tab(
                child: Text(
                  "Expensess",
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
        floatingActionButton: FloatingActionButton(
            backgroundColor: kKarobarcolor,
            onPressed: () {
              // addCategory("petroll", "Income");
              _showCenteredDialog(context);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Content for Tab 1
              Container(
                child: ListView(children: [
                  ListTile(
                    title: Text("General"),
                  )
                ]),
              ),

              // Content for Tab 2
              Center(child: Text('Tab 2 Content $_currentIndex ')),
            ],
          ),
        ));
  }

  Container dropedowncont() {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color.fromARGB(255, 240, 238, 238)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cateroigtypevalue,
            style: kJakartaHeading3.copyWith(fontSize: 15, color: Colors.grey),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              onChanged: (value) {
                setState(() {
                  cateroigtypevalue = value!;
                });
              },
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 0,
              style: const TextStyle(fontSize: 19, color: kGreenColor),
              items: cateroigtype.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: kJakartaHeading3.copyWith(
                        fontSize: 13, color: kKarobarcolor),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  void _showCenteredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              width: 600.0, // Adjust the desired width
              height: 355.0, // Adjust the desired height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New Caterogies",
                    style: kJakartaHeading1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kKarobarcolor,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Caterogies Name",
                    style: kJakartaHeading1.copyWith(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color.fromARGB(255, 240, 238, 238)),
                    child: TextFormField(
                      controller: caterogiesname,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Enter The email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Petrol",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Caterogies Types",
                    style: kJakartaHeading1.copyWith(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  dropedowncont(),
                  const SizedBox(
                    height: 17,
                  ),
                  CustomeBtn(
                      btnTitleName: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPress: () {
                        addCategory();
                        // addCategory(
                        //     context, caterogiesname.text, cateroigtypevalue);
                      })
                ],
              )),
        );
      },
    );
  }
}
