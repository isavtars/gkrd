//validPhone number ui/ux
String? validatingPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    } else if (isValidNepalPhoneNumber(value) == false) {
      return "Enter valid phonenumber";
    }

    return null;
  }

//phonevalidations
bool isValidNepalPhoneNumber(String phoneNumber ) {
  // Remove any leading or trailing spaces from the input.
  phoneNumber = phoneNumber.trim();

  // Check if the length is exactly 10 digits.
  if (phoneNumber.length != 10) {
    return false;
  }

  // Check if the phone number starts with a valid prefix.
  final validPrefixes = ['984', '985', '986', '974', '975', '980', '981', '982'];
  if (!validPrefixes.contains(phoneNumber.substring(0, 3))) {
    return false;
  }

  // Check if all characters in the phone number are digits.
  if (!phoneNumber.contains(RegExp(r'^[0-9]+$'))) {
    return false;
  }

  return true;
}



//validating ammounts ui/ux
String? checkValidAmounts(value) {
    if (value.isEmpty) {
      return 'Please enter correct value';
    }else if(double.parse(value)<0){
          return 'Amount cannot be negative numbers';
    }
    return null;
  }




  //validations Text contents
String? validationsTextContents(value) {
    if (value.isEmpty||value==null) {
      return 'Please Enter Text';
    }
    return null;
  }


