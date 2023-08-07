import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../resources/users_resources.dart';
import '../../styles/color.dart';
import '../../styles/sizeconfig.dart';
import '../../utils/utils.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_inputs.dart';
import '../widgets/tools/all_validations.dart';
// import '../widgets/snackbar.dart';

class UserProfileUpdate extends StatefulWidget {
  const UserProfileUpdate({super.key});

  @override
  State<UserProfileUpdate> createState() => _UserProfileUpdateState();
}

List<String> items = [
  'Less than 30k',
  '30K - 60K',
  '60K - 100K',
  'More than 100K'
];
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
class _UserProfileUpdateState extends State<UserProfileUpdate> {
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final bankAccountController = TextEditingController();
  final kycController = TextEditingController();
  final ageController = TextEditingController();
  String reminderdropvalue = "Income range";

  bool isLoding = false;
  Uint8List? image;

  void selectedImages() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    bankAccountController.dispose();
    kycController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  updateUser() async {

    if (_formKey.currentState!.validate()) {
    // Form is valid, process the data or submit the form
  
    setState(() {
      isLoding = true;
    });

    String res = await UserMethods().updateUserData(
        uid: _auth.currentUser!.uid,
        fullName: fullNameController.text.toString(),
        age: ageController.text.toString(),
        phoneNumber: phoneNumberController.text.toString(),
        bankAccNumber: bankAccountController.text.toString(),
        kyc: kycController.text.toString(),
        incomeRange: reminderdropvalue,
        picfile: image!);

    if (res == "Success") {
      Get.back();
    } else {
      // Don't use 'BuildContext's across async gaps. Try rewriting the code
      // showSnackBar(context, text: res.toString(), color: Colors.red);

//Instead use this code to not reference the 'BuildContext'.

      Future<void>.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.toString()),
            backgroundColor: Colors.red,
          ),
        );
      });

//By using Future<void>.delayed(Duration.zero, () {}), we create a minimal delay to allow the asynchronous gap to be bridged. The showSnackBar call is then executed within the callback function, which is executed asynchronously after a very short delay.
    }

    setState(() {
      isLoding = false;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final height = SizeConfig.blockSizeVertical;
    final width = SizeConfig.blockSizeHorizontal;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            color: Colors.green,
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.keyboard_arrow_left,
                                color: Theme.of(context).iconTheme.color,
                                size: 40)),
                        SizedBox(
                          width: width! * 10,
                        ),
                        Text(
                          "Update Acounts",
                          style: kJakartaBodyBold.copyWith(fontSize: 26),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height! * 1,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 120,
                            width: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).cardColor),
                                shape: BoxShape.circle,
                                color: Theme.of(context).canvasColor),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: image != null
                                    ? CircleAvatar(
                                        radius: 64,
                                        backgroundImage: MemoryImage(image!),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 90,
                                        color: kGrayTextC,
                                      )),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 3,
                            child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3,
                                        color: Theme.of(context).primaryColor),
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor),
                                child: GestureDetector(
                                  onTap: () => selectedImages(),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: kGrayTextC,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 1.2,
                    ),
                    //TextInputFeild

                    Form(
                      key: _formKey,
                        child: Column(
                      children: [
                        CustomeInputs(
                          textEditingController: fullNameController,
                          hintText: "fullName",
                          icons: Icons.account_box,
                          textinputTypes: TextInputType.text,
                          validators:validationsTextContents ,
                        ),
                        SizedBox(
                          height: height * 1.4,
                        ),
                        //pn
                        CustomeInputs(
                          textEditingController: phoneNumberController,
                          hintText: "PhoneNumber",
                          icons: Icons.phone,
                          textinputTypes: TextInputType.phone,
                          validators: validatingPhoneNumber,
                        ),
                        SizedBox(
                          height: height * 1.4,
                        ),
                        //bankacc
                        CustomeInputs(
                          textEditingController: bankAccountController,
                          hintText: "BankAcoountNumber",
                          icons: Icons.account_balance,
                          textinputTypes: TextInputType.number,
                          validators: checkValidAmounts,
                        ),
                        SizedBox(
                          height: height * 1.4,
                        ),
                        CustomeInputs(
                          textEditingController: kycController,
                          hintText: "Kyc Number",
                          icons: Icons.account_balance,
                          textinputTypes: TextInputType.number,
                          validators: checkValidAmounts,
                        ),
                        SizedBox(
                          height: height * 1.4,
                        ),
                        CustomeInputs(
                          textEditingController: ageController,
                          hintText: "Age",
                          icons: Icons.account_circle_outlined,
                          textinputTypes: TextInputType.number,
                          validators: checkedAge,
                        ),
                        SizedBox(
                          height: height * 1.4,
                        ),
                        //dropedown
                        CustomeInputWithdrop(
                            perfix: Icons.currency_rupee,
                            hintText: reminderdropvalue,
                            // suffixIcon: Icons.keyboard_arrow_down,
                            suffix: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                iconSize: 22,
                                style: kJakartaHeading4.copyWith(
                                    color: kGrayTextfieldC, fontSize: 19),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                items: items.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: kJakartaHeading3.copyWith(
                                          fontSize: 19, color: kGreenColor),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    reminderdropvalue = value!;
                                  });
                                },
                              ),
                            )),

                        SizedBox(
                          height: height * 1.4,
                        ),

                        CustomeBtn(
                          btnTitleName: isLoding
                              ? const CircularProgressIndicator(color: Colors.white,)
                              : Text(
                                  "Continue",
                                  style: kJakartaHeading3.copyWith(
                                      color: Colors.white,
                                      fontSize: height * 2),
                                ),
                          onPress: updateUser,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: height * 5,
                    ),
                  ],
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}

//TODO FOR THIS SCREEN
//validate INCOME RANGE


