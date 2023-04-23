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

import 'package:wachup_android_12/shared/constants.dart';
import 'package:wachup_android_12/widgets/attachment_tile.dart';

class AttachmentPage extends StatefulWidget {
  final String? creator;
  final String? reelId;
  final String? reelName;

  final bool isView;

  const AttachmentPage(
      {Key? key,
      required this.creator,
      required this.reelId,
      required this.reelName,
      required this.isView})
      : super(key: key);

  @override
  State<AttachmentPage> createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  Stream<QuerySnapshot>? files;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  String name = "";

  @override
  void initState() {
    getFileContents();
    super.initState();
    setState(() {
      print(widget.reelName);
      name = widget.reelName!;
    });
  }

  getFileContents() {
    DatabaseService().getAttachments(widget.reelId!).then((val) {
      setState(() {
        files = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          backgroundColor: Constants().customColor1,
          appBar: buildAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Text(
                      widget.reelName!,
                      style: TextStyle(
                          color: Constants().customBackColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
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
                ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                        color: Constants().customBackColor,
                        child: fileContents()),
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
                                  context, "topic_click_buttons"))),
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
            backgroundColor: Constants().customColor1,
            elevation: 0,
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
                  return AttachmentTile(
                    reelId: widget.reelId!,
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

  addFile() {
    nextScreen(context, UploadFilePage(topicId: widget.reelId!));
  }
}
