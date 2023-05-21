import 'package:flutter/material.dart';
import 'package:wachup_android_12/shared/constants.dart';

class IdentificationTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  IdentificationTile(
      {required this.option,
      required this.description,
      required this.correctAnswer,
      required this.optionSelected});

  @override
  _IdentificationTileState createState() => _IdentificationTileState();
}

class _IdentificationTileState extends State<IdentificationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.description == widget.optionSelected
                    ? widget.optionSelected == widget.correctAnswer
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7)
                    : Colors.grey,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              "${widget.option}",
              style: TextStyle(
                  color: widget.optionSelected == widget.description
                      ? widget.correctAnswer == widget.optionSelected
                          ? Colors.green.withOpacity(0.7)
                          : Colors.red
                      : Colors.grey),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            widget.description,
            style: TextStyle(fontSize: 17, color: Colors.black54),
          ),
          SizedBox(
            width: 8,
          ),
          InkWell(
            //onTap: () => Navigator.of(context).push(
            // MaterialPageRoute(
            //   builder: (context) => SignupScreen(),
            // ),
            //),
            child: Text(
              'Register',
              style: TextStyle(fontSize: 20, color: Constants().customColor2),
            ),
          )
        ],
      ),
    );
  }
}
