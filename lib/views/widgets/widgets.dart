import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/shared/constants.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(
            text: Locales.string(context, "games_title"),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Constants().customForeColor)),
      ],
    ),
  );
}

Widget blueButton({BuildContext? context, String? label, buttonWidth}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    // height: 50,
    decoration: BoxDecoration(
      color: Constants().customColor2,
      borderRadius: BorderRadius.circular(30),
    ),
    alignment: Alignment.center,
    width: buttonWidth != null
        ? buttonWidth
        : MediaQuery.of(context!).size.width - 48,
    child: Text(
      label!,
      style: TextStyle(
        color: Constants().customBackColor,
        fontSize: 16,
      ),
    ),
  );
}
