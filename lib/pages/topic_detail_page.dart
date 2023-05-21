import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/constants.dart';
import 'package:wachup_android_12/pages/screens/score_page.dart';
import 'package:wachup_android_12/pages/topic_page.dart';
import 'package:wachup_android_12/pages/upload/upload_file.dart';
import 'package:wachup_android_12/pages/upload/upload_image.dart';
import 'package:wachup_android_12/pages/upload/upload_video.dart';
import 'package:wachup_android_12/service/database_service.dart';
import 'package:wachup_android_12/views/createQuiz.dart';
//import 'package:wachup_android_12/views/home.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/databaseQuiz.dart';
import '../shared/constants.dart';
import '../views/play_quiz.dart';
import '../widgets/file_tile.dart';
import '../widgets/image_tile.dart';
import '../widgets/video_tile.dart';

class TopicDetailPage extends StatefulWidget {
  final String currentUserName;
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;

  final bool isView;

  const TopicDetailPage(
      {Key? key,
      required this.currentUserName,
      required this.creator,
      required this.topicId,
      required this.topicName,
      required this.topicSubject,
      required this.isView})
      : super(key: key);

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  Stream<QuerySnapshot>? files;
  Stream<QuerySnapshot>? videos;
  Stream<QuerySnapshot>? images;
  dynamic quizStream;
  DatabaseQuizService databaseService = new DatabaseQuizService();

  TextEditingController messageController = TextEditingController();
  String admin = "";

  String subject = "";
  String name = "";
  String about = "";

  String old_id = "";

  @override
  void initState() {
    getTopicAbout();
    getFileContents();
    getVideoContents();
    getImageContents();
    databaseService.getQuizDataPerTopic(widget.topicId).then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
    setState(() {
      subject = widget.topicSubject;
      name = widget.topicName;
      about = about;
      old_id = "${widget.topicId}_${widget.topicName}_${widget.topicSubject}";
    });
  }

  getFileContents() {
    DatabaseService().getFileContent(widget.topicId).then((val) {
      setState(() {
        files = val;
      });
    });
  }

  getVideoContents() {
    DatabaseService().getVideoContent(widget.topicId).then((val) {
      setState(() {
        videos = val;
      });
    });
  }

  getImageContents() {
    DatabaseService().getImageContent(widget.topicId).then((val) {
      setState(() {
        images = val;
      });
    });
  }

  getTopicAbout() {
    DatabaseService().getTopicAbout(widget.topicId).then((val) {
      setState(() {
        about = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          backgroundColor: Constants().customColor1,
          appBar: buildAppBar(),
          body:
              //buildContainer(context),
              //buildStackContent(context),
              //customLiquid()
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    !widget.isView
                        ? TextFormField(
                            initialValue: widget.topicSubject,
                            onChanged: (val) {
                              setState(() {
                                subject = val;
                              });
                            },
                            style: TextStyle(
                              color: Constants().customBackColor,
                              fontSize: 15,
                            ),
                          )
                        : Text(
                            widget.topicSubject,
                            style: TextStyle(
                              color: Constants().customBackColor,
                              fontSize: 15,
                            ),
                          ),
                    const SizedBox(height: 5),
                    !widget.isView
                        ? TextFormField(
                            initialValue: widget.topicName,
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w600),
                          )
                        : Text(
                            widget.topicName,
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w600),
                          ),
                    const SizedBox(height: 15),
                    !widget.isView
                        ? TextFormField(
                            key: Key(about),
                            initialValue: about,
                            onChanged: (val) {
                              setState(() {
                                about = val;
                              });
                            },
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          )
                        : Text(
                            about,
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                color: Constants().customBackColor,
                child: TabBar(tabs: [
                  Tab(
                      icon: Icon(
                    Icons.file_copy_rounded,
                    color: Constants().customColor1,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.photo,
                    color: Constants().customColor1,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.video_camera_back_rounded,
                    color: Constants().customColor1,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.quiz_rounded,
                    color: Constants().customColor1,
                  ))
                ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                        color: Constants().customBackColor,
                        child: fileContents()),
                    Container(
                        color: Constants().customBackColor,
                        child: imageContents()),
                    Container(
                        color: Constants().customBackColor,
                        child: videoContents()),
                    Container(
                        color: Constants().customBackColor, child: quizList())
                  ],
                ),
              ),
              widget.isView
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //color: Constants().customBackColor,
                        child: Row(children: [
                          Expanded(
                              child: Text(Locales.string(
                                  context, "topic_click_buttons"))
                              //     TextField(
                              //   controller: messageController,
                              //   style: TextStyle(color: Constants().customBackColor),
                              //   decoration: InputDecoration(
                              //     hintText: Locales.string(context, "message_send_hint"),
                              //     hintStyle: TextStyle(
                              //         color: Constants().customBackColor, fontSize: 16),
                              //     border: InputBorder.none,
                              //   ),
                              // )
                              ),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              addFile();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.upload_file_rounded,
                                color: Constants().customBackColor,
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              addImage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.add_photo_alternate_rounded,
                                color: Constants().customBackColor,
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              addVideo();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.add_to_photos_outlined,
                                color: Constants().customBackColor,
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              nextScreenReplace(
                                  context,
                                  CreateQuiz(
                                    currentUser: widget.currentUserName,
                                    topicId: widget.topicId,
                                    creator: widget.creator,
                                    topicName: widget.topicName,
                                    topicSubject: widget.topicSubject,
                                    isView: widget.isView,
                                  ));
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.video_call_rounded,
                                color: Constants().customBackColor,
                              )),
                            ),
                          )
                        ]),
                      ),
                    ),
              // const SizedBox(
              //   height: 5,
              // )
            ],
          )),
    );
  }

  AppBar buildAppBar() {
    return widget.isView
        ? AppBar(
            backgroundColor: Constants().customColor1,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
                IconButton(
                    onPressed: () {
                      nextScreenReplace(context, TopicPage());
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    )),
              ])
        : AppBar(
            backgroundColor: Constants().customColor1,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    nextScreenReplace(context, TopicPage());
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  )),
              IconButton(
                  onPressed: () {
                    saveDetails();
                  },
                  icon: const Icon(
                    Icons.save_rounded,
                  )),
              IconButton(
                  onPressed: () {
                    deleteDetails();
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                  ))
            ],
          );
  }

  Stack buildStackContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        // chat messages here
        fileContents(),
        videoContents(),
        imageContents(),
        quizList(),
        widget.isView
            ? Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  width: MediaQuery.of(context).size.width,
                  color: Constants().customForeColor,
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      controller: messageController,
                      style: TextStyle(color: Constants().customBackColor),
                      decoration: InputDecoration(
                        hintText: Locales.string(context, "message_send_hint"),
                        hintStyle: TextStyle(
                            color: Constants().customBackColor, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    )),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        addFile();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.upload_file_rounded,
                          color: Constants().customBackColor,
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        addImage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.add_photo_alternate_rounded,
                          color: Constants().customBackColor,
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        addVideo();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.add_reaction_rounded,
                          color: Constants().customBackColor,
                        )),
                      ),
                    )
                  ]),
                ),
              )
            : Container()
      ],
    );
  }

  fileContents() {
    return StreamBuilder(
      stream: files,
      builder: (context, AsyncSnapshot snapshot) {
        //snapshot.hasData ? print(1) : print(2);
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print(index);
                  return FileTile(
                    topicId: widget.topicId,
                    fileId: snapshot.data.docs[index]['id'],
                    content: snapshot.data.docs[index]['content'],
                    url: snapshot.data.docs[index]['content2'],
                    isView: widget.isView,
                  );
                },
              )
            : Container();
      },
    );
  }

  videoContents() {
    return StreamBuilder(
      stream: videos,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return VideoTile(
                    topicId: widget.topicId,
                    fileId: snapshot.data.docs[index]['id'],
                    content: snapshot.data.docs[index]['content'],
                    url: snapshot.data.docs[index]['content2'],
                    isView: widget.isView,
                  );
                },
              )
            : Container();
      },
    );
  }

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: quizStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, index) {
                final doc = docs[index];
                final imgUrl = doc["quizImgUrl"];
                final desc = doc["quizDesc"];
                final title = doc["quizTitle"];
                final quizId = doc.id;

                return QuizTile(
                  imgUrl: imgUrl,
                  desc: desc,
                  title: title,
                  quizId: quizId,
                  creator: widget.creator,
                  currentUserName: widget.currentUserName,
                  topicId: widget.topicId,
                  topicName: widget.topicName,
                  topicSubject: widget.topicSubject,
                  isView: widget.isView,
                );
              },
            );
          }
        },
      ),
    );
  }

  imageContents() {
    return StreamBuilder(
      stream: images,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ImageTile(
                    topicId: widget.topicId,
                    fileId: snapshot.data.docs[index]['id'],
                    content: snapshot.data.docs[index]['content'],
                    url: snapshot.data.docs[index]['content2'],
                    isView: widget.isView,
                  );
                },
              )
            : Container();
      },
    );
  }

  saveDetails() async {
    // print(widget.topicId);
    // print(name);
    // print(subject);
    // print(about);
    // print(FirebaseAuth.instance.currentUser!.uid);
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .updateTopicDetails(widget.topicId, name, subject, about, old_id);

    setState(() {
      old_id = "${widget.topicId}_${name}_$subject";
    });
    //print(old_id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: LocaleText('topic_detail_saved')));
  }

  deleteDetails() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete",
              style: TextStyle(
                  color: Constants().customForeColor,
                  fontWeight: FontWeight.w600),
            ),
            content: Text("Are you sure you want to delete this topic?"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Constants().customColor2,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await DatabaseService(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                      .deleteTopic(widget.topicId, old_id);

                  setState(() {
                    old_id = "${widget.topicId}_${name}_$subject";
                  });
                  //print(old_id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: LocaleText('topic_detail_saved')));
                },
                icon: Icon(
                  Icons.done_outline,
                  color: Constants().customColor1,
                ),
              ),
            ],
          );
        });
  }

  addFile() {
    nextScreen(context, UploadFilePage(topicId: widget.topicId));
  }

  addVideo() {
    nextScreen(context, UploadVideoPage(topicId: widget.topicId));
  }

  addImage() {
    nextScreen(context, UploadImagePage(topicId: widget.topicId));
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;

  final String currentUserName;
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;

  final bool isView;

  QuizTile(
      {required this.imgUrl,
      required this.title,
      required this.desc,
      required this.quizId,
      required this.currentUserName,
      required this.creator,
      required this.topicId,
      required this.topicName,
      required this.topicSubject,
      required this.isView});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: MediaQuery.of(context).size.width - 48,
                  color: Constants().customColor1,
                )
                // Image.network(
                //   imgUrl,
                //   width: MediaQuery.of(context).size.width - 48,
                //   fit: BoxFit.cover,
                // ),
                ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8)),
              //color: Colors.blue,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Take the quiz",
                      style: TextStyle(
                          color: Constants().customForeColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //nextScreen(context, const RegisterPage());
                          nextScreen(
                              context,
                              PlayQuiz(
                                  quizId: quizId,
                                  currentUser: currentUserName,
                                  creator: creator,
                                  topicId: topicId,
                                  topicName: topicName,
                                  topicSubject: topicSubject,
                                  isView: isView));
                        })),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "See Scores",
                      style: TextStyle(
                          color: Constants().customForeColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //nextScreen(context, const RegisterPage());
                          nextScreen(
                              context,
                              ScorePage(
                                quizId: quizId,
                                quizName: title,
                                userName: currentUserName,
                              ));
                        })),
                  Text.rich(TextSpan(
                      text: "Delete Quiz",
                      style: TextStyle(
                          color: Constants().customForeColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete Quiz",
                                    style: TextStyle(
                                        color: Constants().customForeColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  content: Text(
                                      "Are you sure you want to delete this quiz?"),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Constants().customColor2,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        DatabaseService()
                                            .deleteQuizContent(quizId);
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.done_outline,
                                        color: Constants().customColor1,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
