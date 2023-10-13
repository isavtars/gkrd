import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkrd/Screen/Dashboard/Screen/dashboard_screen.dart';
import 'package:gkrd/Screen/widgets/custom_buttons.dart';
import 'package:gkrd/model/goods_models.dart';

import '../../../styles/color.dart';
import '../Sql/sqlhelperdgoods.dart';

class AddGoodsscreen extends StatefulWidget {
  const AddGoodsscreen({super.key});

  @override
  State<AddGoodsscreen> createState() => _AddGoodsscreenState();
}

class _AddGoodsscreenState extends State<AddGoodsscreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  double price = 0.0;
  String quantity = "1kg";
  IconData selectedIcon = Icons.star;
  final dbHelper = SQLHelperGoods();
  submitform() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      print('Name: $name');
      print('Price: $price');
      print('Quantity: $quantity');
      print('Selected Icon: $selectedIcon');

      final item = GoodsItem(
        name: name,
        price: price,
        quantity: quantity,
        icon: selectedIcon.toString(),
      );

      await dbHelper.createTask(item);
      Get.to(const Dashboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kKarobarcolor,
        leading: IconButton(
          onPressed: () {
            Get.off(const Dashboard());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text("Add Goods Screen", style: kJakartaBodyBold.copyWith()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //Name
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Enter Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //prices
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Enter Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          price = double.parse(value!);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Quintity
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Enter Quantity'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantity = value!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //icons
                      DropdownButtonFormField<IconData>(
                        value: selectedIcon,
                        items: const [
                          DropdownMenuItem(
                            value: Icons.star,
                            child: Icon(Icons.star),
                          ),
                          DropdownMenuItem(
                            value: Icons.favorite,
                            child: Icon(Icons.favorite),
                          ),
                          // Add more icons as needed
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedIcon = value!;
                          });
                        },
                        decoration:
                            const InputDecoration(labelText: 'Select an Icon'),
                      ),
                      const SizedBox(height: 20),
                      CustomeBtn(
                          btnTitleName: Text(
                            "Save",
                            style:
                                kJakartaBodyBold.copyWith(color: Colors.white),
                          ),
                          onPress: () {
                            submitform();
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
