import 'package:flutter/material.dart';
import 'package:wachup_android_12/shared/constants.dart';

final textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
      color: Constants().customForeColor, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().customColor1, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().customColor3, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().customColor2, width: 2),
  ),
);

final subjectInputDecoration = InputDecoration(
  labelStyle: TextStyle(
      color: Constants().customForeColor,
      fontWeight: FontWeight.w300,
      fontSize: 15),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().customColor1, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().customColor3, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().customColor2, width: 2),
  ),
);

//Go to next page
void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "Ok",
      onPressed: () {},
      textColor: Constants().customBackColor,
    ),
  ));
}
