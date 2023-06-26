import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

// userDatePickwer(context) async {
//    NepaliDateTime? _selectedDateTime = await picker.showMaterialDatePicker(
//     context: context,
//     initialDate: NepaliDateTime.now(),
//     firstDate: NepaliDateTime(2000),
//     lastDate: NepaliDateTime(2090),
//     initialDatePickerMode: DatePickerMode.day,
//   );

//   }

// nepali date Time formatted

dateformater({required var dateandTime}) {
  return NepaliDateFormat.yMMMEd(Language.english).format(dateandTime);
}




//date formatteds
dynamic formatDate(String date) {
  final dynamic newDate = DateTime.parse(date);
  final DateFormat formatter = DateFormat('E, d MMMM,   hh:mm a');
  final dynamic formatted = formatter.format(newDate);
  return formatted;
}
