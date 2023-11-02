import 'package:flutter/material.dart';

import '../ui/theme_class.dart';

Widget buttonWidget(String buttonTitle, Function onClick, BuildContext context,
        {bool isSignup = false}) =>
    Center(
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 15,
          ),
          child: isSignup
              ? CircularProgressIndicator()
              : Text(
                  buttonTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
        color: Colors.blue,
        onPressed: () {
          onClick();
        },
      ),
    );

Widget titleLoginRegisterWidget(String text) => Container(
      child: Text(
        text,
        style: ThemeClass.titleTextStyleGreen,
      ),
    );

Widget subTitleLoginRegisteWidget(String text) => Container(
      child: Text(
        text,
      ),
    );
