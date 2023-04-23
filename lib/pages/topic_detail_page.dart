import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/pages/upload/upload_file.dart';
import 'package:wachup_android_12/pages/upload/upload_image.dart';
import 'package:wachup_android_12/pages/upload/upload_video.dart';
import 'package:wachup_android_12/service/database_service.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../widgets/file_tile.dart';
import '../widgets/image_tile.dart';
import '../widgets/video_tile.dart';

class TopicDetailPage extends StatefulWidget {
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;

  final bool isView;

  const TopicDetailPage(
      {Key? key,
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
      length: 3,
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
          )
        : AppBar(
            actions: [
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
            backgroundColor: Constants().customColor1,
            elevation: 0,
          );
  }

  Stack buildStackContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        // chat messages here
        fileContents(),
        videoContents(),
        imageContents(),
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
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .deleteTopic(widget.topicId, old_id);

    setState(() {
      old_id = "${widget.topicId}_${name}_$subject";
    });
    //print(old_id);
    Navigator.pop(context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: LocaleText('topic_detail_saved')));
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
