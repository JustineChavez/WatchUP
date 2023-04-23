import 'package:flutter/material.dart';
import 'package:wachup_android_12/views/home.dart';
import 'package:wachup_android_12/views/widgets/widgets.dart';
import 'package:wachup_android_12/widgets/widgets.dart';

class PostResults extends StatefulWidget {
  final int correct, incorrect, total;
  final quizId;
  const PostResults(
      {required this.correct,
      required this.incorrect,
      required this.total,
      required this.quizId});

  @override
  _PostResultsState createState() => _PostResultsState();
}

class _PostResultsState extends State<PostResults> {
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
                  //Navigator.pop(context);
                  nextScreen(context, Quiz());
                },
                child: blueButton(
                  context: context,
                  label: "Go to Home",
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