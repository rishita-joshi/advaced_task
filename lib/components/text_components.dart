import 'package:flutter/material.dart';

import '../ui/theme_class.dart';

class EventTextBoxWidget extends StatelessWidget {
  const EventTextBoxWidget(
      {Key? key,
      required this.hintText,
      this.isSufix = false,
      this.isPassword = false,
      this.callback,
      this.icon,
      this.prefixWidget,
      required this.controller,
      required this.inputType,
      this.validator})
      : super(key: key);

  final String hintText;
  final bool? isSufix;
  final Function? callback;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final Widget? prefixWidget;
  final TextInputType inputType;
  final String Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white54,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          color: ThemeClass.greyColor,
          fontSize: 18,
        ),
        keyboardType: inputType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: prefixWidget,
          suffixIcon: isSufix!
              ? IconButton(
                  icon: Icon(
                    icon,
                    color: ThemeClass.greenColor,
                  ),
                  onPressed: () {
                    callback!();
                    // _selectTime();
                  },
                )
              : null,
          focusColor: ThemeClass.greenColor,
          hintText: hintText,
          prefixStyle: TextStyle(color: ThemeClass.greyColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ThemeClass.greyColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ThemeClass.greyColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
