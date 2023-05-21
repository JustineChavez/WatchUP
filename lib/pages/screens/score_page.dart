import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/service/database_service.dart';
import 'package:wachup_android_12/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:wachup_android_12/shared/constants.dart';

class ScorePage extends StatefulWidget {
  final String? quizId;
  final String? quizName;
  final String? userName;

  const ScorePage(
      {Key? key,
      required this.quizId,
      required this.quizName,
      required this.userName})
      : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Stream<QuerySnapshot>? scores;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getReelComments();
    super.initState();
  }

  getReelComments() {
    DatabaseService().getQuizScore(widget.quizId!).then((val) {
      setState(() {
        scores = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.quizName!,
            style: TextStyle(
                color: Constants().customBackColor,
                fontWeight: FontWeight.w600,
                fontSize: 20)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          _scores()
        ],
      ),
    );
  }

  _scores() {
    return StreamBuilder(
      stream: scores,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['result'],
                    sender: snapshot.data.docs[index]['tester'],
                    sentByMe: true,
                    ts: snapshot.data.docs[index]['time'],
                  );
                },
              )
            : Container();
      },
    );
  }
}
