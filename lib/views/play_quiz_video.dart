import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/models/video_model.dart';
import 'package:wachup_android_12/pages/upload/upload_reel.dart';
import 'package:wachup_android_12/shared/constants.dart';
import 'package:wachup_android_12/views/play_post_quiz.dart';
import 'package:wachup_android_12/views/quiz_content.dart';
import '../../shared/drawer.dart';
import '../../widgets/widgets.dart';
import '../services/database.dart';

class PlayQuizVideo extends StatefulWidget {
  String quizId;
  final String currentUser;
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;
  final bool isView;

  final String preTestScore;
  PlayQuizVideo(
      {Key? key,
      required this.quizId,
      required this.currentUser,
      required this.creator,
      required this.topicId,
      required this.topicName,
      required this.topicSubject,
      required this.isView,
      required this.preTestScore})
      : super(key: key);

  @override
  State<PlayQuizVideo> createState() => _PlayQuizVideo();
}

int total = 0;

class _PlayQuizVideo extends State<PlayQuizVideo> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot? videoSnapshot;

  VideoModel getVideoModelFromDataSnapshot(DocumentSnapshot videoSnapshot) {
    VideoModel videoModel = new VideoModel();
    videoModel.videoURL = videoSnapshot["videoURL"];
    print(videoModel.videoURL);
    return videoModel;
  }

  @override
  void initState() {
    databaseService.getsQuizVideo(widget.quizId).then((value) {
      videoSnapshot = value;
      total = videoSnapshot!.docs.length;
      setState(() {
        print('$total this is total');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    PlayPostQuiz(
                      quizId: widget.quizId,
                      creator: widget.creator,
                      currentUser: widget.currentUser,
                      topicId: widget.topicId,
                      topicName: widget.topicName,
                      topicSubject: widget.topicSubject,
                      isView: widget.isView,
                      preTestScore: widget.preTestScore,
                    ));
              },
              icon: const Icon(
                Icons.arrow_forward,
              )),
        ],
        backgroundColor: Constants().customBackColor.withOpacity(0.3),
        elevation: 0,
        title: const Text(
          "Quiz Video",
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        top: false,
        left: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Container(
            child: Stack(
              children: [
                //We need swiper for every content
                Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return QuizVideoContent(
                        src: getVideoModelFromDataSnapshot(
                                videoSnapshot!.docs[index])
                            .videoURL);
                  },
                  itemCount: 1,
                  scrollDirection: Axis.vertical,
                ),
                Container(
                  color: Constants().customBackColor.withOpacity(0.3),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
