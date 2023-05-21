import 'package:flutter/material.dart';

import '../shared/constants.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  final bool isIdentification;

  OptionTile(
      {required this.option,
      required this.description,
      required this.correctAnswer,
      required this.optionSelected,
      required this.isIdentification});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  String answer = "";

  @override
  Widget build(BuildContext context) {
    print(widget.correctAnswer);
    return widget.description == ""
        ? Container()
        : widget.isIdentification
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    TextFormField(
                      // validator: (val) =>
                      //     val!.isEmpty ? "Enter Option 1" : null,
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxWidth: 200),
                        hintText: "Type your answer",
                      ),
                      onChanged: (val) {
                        answer = val;
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    // InkWell(
                    //   //onTap: () => Navigator.of(context).push(
                    //   // MaterialPageRoute(
                    //   //   builder: (context) => SignupScreen(),
                    //   // ),
                    //   //),
                    //   child: Text(
                    //     'Submit',
                    //     style: TextStyle(
                    //         fontSize: 14, color: Constants().customColor2),
                    //   ),
                    // )
                    // Text(
                    //   widget.description,
                    //   style: TextStyle(fontSize: 17, color: Colors.black54),
                    // ),
                  ],
                ),
              )
            : Container(
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
                        widget.description.toLowerCase() == "true" ||
                                widget.description.toLowerCase() == "false"
                            ? ""
                            : widget.option,
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
                  ],
                ),
              );
  }
}
