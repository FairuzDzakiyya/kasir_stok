import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kas_mini_flutter_app/utils/colors.dart';
import 'package:kas_mini_flutter_app/utils/responsif/fsize.dart';

class CustomTextField extends StatelessWidget {
  //:: USAGE?
  // null can be used if the variable type has (?)

  // IF WANT USE prefixIcon || hintText
  //  CustomTextField(
  //   obscureText: false,
  //   height: 50.0,
  //   hintText: 'Email',
  //   prefixIcon: Icon(Icons.email_outlined),
  //  )

  // IF DON'T WANT TO USE prefixIcon || hintText
  //  CustomTextField(
  //   obscureText: false,
  //   height: 50.0,
  //   hintText: null,
  //   prefixIcon: null,
  //  )

  // prefixIcon for the TextField
  // Icon? means that the value can be an Icon or null

  //? note: If the TextField wants to use an Icon then just use the Widget Icon as usual in the prefixIcon argument, then if you don't want to use the prefixIcon then type null in the prefixIcon argument

  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;

  // hintText (placeholder) for the TextField
  final String? hintText;

  // boolean to determine whether the input text is obscured or not
  final bool obscureText;

  // maxLines for the TextField
  final int? maxLines;

  final TextInputType? keyboardType;

  final bool? isFormatter;
  final List<TextInputFormatter>? inputFormatter;

  final TextEditingController? controller;

  late bool? readOnly;

  final Color? textColor;

  Color? fillColor = Colors.grey[200];

  final TextStyle? hintStyle;

  bool? enabled;

  int? maxLength;

  CustomTextField(
      {super.key,
      required this.obscureText,
      required this.hintText,
      required this.prefixIcon,
      required this.controller,
      required this.maxLines,
      required this.suffixIcon,
      this.readOnly,
      this.prefixText,
      this.keyboardType,
      this.textColor,
      this.isFormatter,
      this.inputFormatter,
      this.suffixText,
      this.fillColor,
      this.hintStyle,
      this.maxLength,
      this.enabled,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      inputFormatters: inputFormatter,
      keyboardType: keyboardType,
      readOnly: readOnly ?? false,
      style: TextStyle(color: textColor),
      maxLength: maxLength,
      controller: controller,
      // Decoration for the TextField
      decoration: InputDecoration(
        // filled must be true to fill the TextField with fillColor
        filled: true,
        fillColor: fillColor,

        // Add a hint text (placeholder)
        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(fontSize: SizeHelper.Fsize_mainTextCard(context)),

        // Add a prefix icon (icon on the left side of the TextField)
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        // Add a prefix Text (text on the left side of the TextField)
        prefixText: prefixText,

        // Add a suffix Text (text on the right side of the TextField)
        suffixText: suffixText,

        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            // set border to none
            borderSide: BorderSide.none),

        // If the Input is focused (clicked), the border color and border radius will change
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
          borderSide: const BorderSide(
            // this color is from /utils/colors.dart
            color: primaryColor,
          ),
        ),
      ),
      // secure the text input
      obscureText: obscureText,
      // set the height of the TextField
      maxLines: maxLines,
    );
  }
}
