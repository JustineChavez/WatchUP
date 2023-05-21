import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wachup_android_12/models/question_model.dart';
import 'package:wachup_android_12/services/database.dart';
import 'package:wachup_android_12/views/result.dart';
import 'package:wachup_android_12/widgets/quiz_play_identification.dart';
import 'package:wachup_android_12/widgets/quiz_play_widgets.dart';
import 'package:wachup_android_12/views/widgets/widgets.dart';

import '../shared/constants.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  final String currentUser;
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;
  final bool isView;
  PlayQuiz(
      {required this.quizId,
      required this.currentUser,
      required this.creator,
      required this.topicId,
      required this.topicName,
      required this.topicSubject,
      required this.isView});

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot? questionSnapshot;

  QuestionModel getQuestionModelFromDataSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
    questionModel.question = questionSnapshot["question"];
    questionModel.identification = false;
    List<String> options;
    //  = [
    //   questionSnapshot["option1"],
    //   questionSnapshot["option2"],
    //   questionSnapshot["option3"],
    //   questionSnapshot["option4"],
    // ];

    if (questionSnapshot["option2"] == "") {
      //setState(() {
      //});
      options = [questionSnapshot["option1"]];
      questionModel.option1 = options[0];
      questionModel.option2 = "";
      questionModel.option3 = "";
      questionModel.option4 = "";
      questionModel.identification = true;
    } else if (questionSnapshot["option3"] == "") {
      //setState(() {
      options = [questionSnapshot["option1"], questionSnapshot["option2"]];
      options.shuffle();
      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      questionModel.option3 = "";
      questionModel.option4 = "";
      //});
    } else if (questionSnapshot["option4"] == "") {
      //setState(() {
      options = [
        questionSnapshot["option1"],
        questionSnapshot["option2"],
        questionSnapshot["option3"]
      ];
      options.shuffle();
      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      questionModel.option3 = options[2];
      questionModel.option4 = "";
      //});
    } else {
      //setState(() {
      options = [
        questionSnapshot["option1"],
        questionSnapshot["option2"],
        questionSnapshot["option3"],
        questionSnapshot["option4"],
      ];
      options.shuffle();
      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      questionModel.option3 = options[2];
      questionModel.option4 = options[3];
      //});
    }

    //options.shuffle();
    // questionModel.option1 = options[0];
    // questionModel.option2 = options[1];
    // questionModel.option3 = options[2];
    // questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    print("Quiz Id : ${widget.quizId}");
    databaseService.getsQuizData(widget.quizId).then((value) {
      questionSnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = questionSnapshot!.docs.length;
      setState(() {
        print('$total this is total');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pre-Quiz"), //appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            questionSnapshot == null
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: questionSnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      return QuizPlayTile(
                          questionModel: getQuestionModelFromDataSnapshot(
                              questionSnapshot!.docs[index]),
                          index: index);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Results(
                  correct: _correct,
                  incorrect: _incorrect,
                  total: total,
                  quizId: widget.quizId,
                  creator: widget.creator,
                  currentUser: widget.currentUser,
                  topicId: widget.topicId,
                  topicName: widget.topicName,
                  topicSubject: widget.topicSubject,
                  isView: widget.isView,
                ),
              ));
        },
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  String answer = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Q${widget.index + 1} ${widget.questionModel.question}",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          // IdentificationTile(
          //     correctAnswer: widget.questionModel.correctOption,
          //     description: widget.questionModel.option1,
          //     option: "",
          //     optionSelected: optionSelected,
          //   )
          GestureDetector(
            onTap: () {
              if (widget.questionModel.identification) return;
              if (!widget.questionModel.answered) {
                //Correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: Row(
              children: [
                widget.questionModel.identification
                    ? TextFormField(
                        // validator: (val) =>
                        //     val!.isEmpty ? "Enter Option 1" : null,
                        decoration: InputDecoration(
                          constraints: BoxConstraints(maxWidth: 200),
                          hintText: "Type your answer",
                        ),
                        onChanged: (val) {
                          answer = val;
                        },
                      )
                    : OptionTile(
                        correctAnswer: widget.questionModel.correctOption,
                        description: widget.questionModel.option1,
                        option: "A",
                        optionSelected: optionSelected,
                        isIdentification: widget.questionModel.identification,
                      ),
                widget.questionModel.identification
                    ? InkWell(
                        onTap: () {
                          if (!widget.questionModel.answered) {
                            //Correct
                            if (answer.toLowerCase() ==
                                widget.questionModel.correctOption
                                    .toLowerCase()) {
                              optionSelected = widget.questionModel.option1;
                              widget.questionModel.answered = true;
                              _correct = _correct + 1;
                              _notAttempted = _notAttempted - 1;
                              setState(() {});
                            } else {
                              optionSelected = widget.questionModel.option1;
                              widget.questionModel.answered = true;
                              _incorrect = _incorrect + 1;
                              _notAttempted = _notAttempted - 1;
                              setState(() {});
                            }
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 14, color: Constants().customColor2),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //Correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option2,
              option: "B",
              optionSelected: optionSelected,
              isIdentification: widget.questionModel.identification,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //Correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option3,
              option: "C",
              optionSelected: optionSelected,
              isIdentification: widget.questionModel.identification,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //Correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option4,
              option: "D",
              optionSelected: optionSelected,
              isIdentification: widget.questionModel.identification,
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
