


// import 'package:flutter/material.dart';

// import '../../model/goods_models.dart';

// class TextFormFieldWithAutocomplete<T> extends StatefulWidget {
//   final List<Goods> options;
//   final Function(Goods) onSelected;
//   final String hintText;

//   const TextFormFieldWithAutocomplete({super.key, 
//     required this.options,
//     required this.onSelected,
//     required this.hintText,
//   });

//   @override
//   _TextFormFieldWithAutocompleteState<T
  
//   > createState() =>
//       _TextFormFieldWithAutocompleteState<T>();
// }

// class _TextFormFieldWithAutocompleteState<T>
//     extends State<TextFormFieldWithAutocomplete<T>> {
      
//   TextEditingController _textEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Autocomplete<Goods>(
//       optionsBuilder: (TextEditingValue textEditingValue) {
//         if (textEditingValue.text == '') {
//           return const Iterable<Goods>.empty();
//         }
//         return widget.options.where((item) {
//           return item.toString().toLowerCase().contains(
//                 textEditingValue.text.toLowerCase(),
//               );
//         });
//       },
//       onSelected: (Goods selectedItem) {
//         _textEditingController.text = selectedItem.toString();
//         widget.onSelected(selectedItem);
//       },
//       displayStringForOption: (Goods item) => item.toString(),
//       fieldViewBuilder: (BuildContext context,
//           TextEditingController textEditingController, FocusNode focusNode,
//           VoidCallback onFieldSubmitted) {
//         _textEditingController = textEditingController;
//         return TextFormField(
//           controller: _textEditingController,
//           focusNode: focusNode,
//           onFieldSubmitted: (value) {
//             onFieldSubmitted();
//           },
//           decoration: InputDecoration(
//             hintText: widget.hintText,
//                  enabledBorder: InputBorder.none, // Remove border
//                       focusedBorder: InputBorder.none, // Remove border when focused
//                       errorBorder: InputBorder.none,
//           ),
//         );
//       },
//     );
//   }
// }


