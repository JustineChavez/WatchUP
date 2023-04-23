import 'package:flutter/material.dart';
import 'package:wachup_android_12/views/play_quiz_video.dart';
import 'package:wachup_android_12/views/quiz_content.dart';
import 'package:wachup_android_12/views/widgets/widgets.dart';

import '../widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  final quizId;
  const Results(
      {required this.correct,
      required this.incorrect,
      required this.total,
      required this.quizId});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${widget.correct}/${widget.total}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "You answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 14,
              ),
              GestureDetector(
                onTap: () {
                  nextScreen(context, PlayQuizVideo(quizId: widget.quizId));
                  //Navigator.pop(context);
                },
                child: blueButton(
                  context: context,
                  label: "Play Video",
                  buttonWidth: MediaQuery.of(context).size.width / 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
