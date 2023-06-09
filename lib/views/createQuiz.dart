import 'package:flutter/material.dart';
import 'package:wachup_android_12/services/databaseQuiz.dart';
import 'package:wachup_android_12/views/addQuestion.dart';
import 'package:wachup_android_12/views/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  final String currentUser;
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;
  final bool isView;

  const CreateQuiz(
      {Key? key,
      required this.currentUser,
      required this.creator,
      required this.topicId,
      required this.topicName,
      required this.topicSubject,
      required this.isView})
      : super(key: key);

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageUrl = "";
  String quizTitle = "";
  String quizDescription = "";
  String quizId = "";

  DatabaseQuizService databaseService = new DatabaseQuizService();

  bool _isLoading = false;

  createQuizOnline() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16);
      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDescription,
        "quizTopicId": widget.topicId
      };
      await databaseService.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(
                    value,
                    widget.creator,
                    widget.currentUser,
                    widget.topicId,
                    widget.topicName,
                    widget.topicSubject,
                    widget.isView),
              ));
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
          iconTheme: IconThemeData(color: Colors.black87)),
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
                    // TextFormField(
                    //   validator: (val) =>
                    //       val!.isEmpty ? "Enter Image Url" : null,
                    //   decoration: InputDecoration(
                    //     hintText: "Quiz Image Url",
                    //   ),
                    //   onChanged: (val) {
                    //     quizImageUrl = val;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 6,
                    // ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Title" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Title",
                      ),
                      onChanged: (val) {
                        quizTitle = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Quiz Description" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Description",
                      ),
                      onChanged: (val) {
                        quizDescription = val;
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        createQuizOnline();
                      },
                      child: blueButton(context: context, label: "Create Quiz"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
