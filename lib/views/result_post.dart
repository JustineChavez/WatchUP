import 'package:flutter/material.dart';
import 'package:wachup_android_12/pages/topic_detail_page.dart';
import 'package:wachup_android_12/views/home.dart';
import 'package:wachup_android_12/views/widgets/widgets.dart';
import 'package:wachup_android_12/widgets/widgets.dart';

import '../service/database_service.dart';

class PostResults extends StatefulWidget {
  final int correct, incorrect, total;
  final quizId;
  final String currentUser;
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;
  final bool isView;

  final String preTestScore;

  const PostResults(
      {required this.correct,
      required this.incorrect,
      required this.total,
      required this.quizId,
      required this.currentUser,
      required this.creator,
      required this.topicId,
      required this.topicName,
      required this.topicSubject,
      required this.isView,
      required this.preTestScore});

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
                  addScores();
                  nextScreen(
                      context,
                      TopicDetailPage(
                          currentUserName: widget.currentUser,
                          creator: widget.creator,
                          topicId: widget.topicId,
                          topicName: widget.topicName,
                          topicSubject: widget.topicSubject,
                          isView: widget.isView));
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

  addScores() {
    Map<String, dynamic> resultQuiz = {
      "result":
          "${widget.preTestScore}; Post-Test: ${widget.correct}/${widget.correct + widget.incorrect}",
      "tester": widget.currentUser,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    DatabaseService().addScores(widget.quizId, resultQuiz);
  }
}
