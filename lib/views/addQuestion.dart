import 'package:flutter/material.dart';
import 'package:wachup_android_12/services/databaseQuiz.dart';
import 'package:wachup_android_12/shared/constants.dart';
import 'package:wachup_android_12/views/upload_quiz_video.dart';
import 'package:wachup_android_12/views/widgets/widgets.dart';
import 'package:wachup_android_12/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  final String currentUser;
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;
  final bool isView;
  AddQuestion(this.quizId, this.currentUser, this.creator, this.topicId,
      this.topicName, this.topicSubject, this.isView);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question = "";
  String option1 = "";
  String option2 = "";
  String option3 = "";
  String option4 = "";
  bool _isLoading = false;

  DatabaseQuizService databaseService = new DatabaseQuizService();

  uploadQuestionData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };
      await databaseService
          .addQuestionData(questionMap, widget.quizId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: <Widget>[
                    Text(
                      '2-4 Options means multiple choices;\r\n2 Options can be set as true or false;\r\n1 Option means identification.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Constants().customColor2),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Question" : null,
                      decoration: InputDecoration(
                        hintText: "Question",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Option 1" : null,
                      decoration: InputDecoration(
                        hintText: "Option 1 (Correct Answer)",
                      ),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      // validator: (val) =>
                      //     val!.isEmpty ? "Enter Option 2" : null,
                      decoration: InputDecoration(
                        hintText: "Option 2",
                      ),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      // validator: (val) =>
                      //     val!.isEmpty ? "Enter Option 3" : null,
                      decoration: InputDecoration(
                        hintText: "Option 3",
                      ),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      // validator: (val) =>
                      //     val!.isEmpty ? "Enter Option 4" : null,
                      decoration: InputDecoration(
                        hintText: "Option 4",
                      ),
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            //Navigator.pop(context);
                            nextScreen(
                                context,
                                UploadQuizVideoPage(
                                  quizId: widget.quizId,
                                  currentUserName: widget.currentUser,
                                  topicId: widget.topicId,
                                  creator: widget.creator,
                                  topicName: widget.topicName,
                                  topicSubject: widget.topicName,
                                  isView: widget.isView,
                                ));
                          },
                          child: blueButton(
                            context: context,
                            label: "Add video",
                            buttonWidth:
                                MediaQuery.of(context).size.width / 2 - 36,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            uploadQuestionData();
                          },
                          child: blueButton(
                            context: context,
                            label: "Add Question",
                            buttonWidth:
                                MediaQuery.of(context).size.width / 2 - 36,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
