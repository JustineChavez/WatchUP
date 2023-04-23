import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/pages/topic_detail_page.dart';
import 'package:wachup_android_12/widgets/widgets.dart';

import '../helper/helper_function.dart';
import '../pages/auth/login_page.dart';
import '../service/database_service.dart';
import '../shared/constants.dart';
import '../shared/constants_v2.dart';

class TopicTile extends StatefulWidget {
  final String creatorName;
  final String topicId;
  final String topicName;
  final String topicSubject;
  const TopicTile(
      {Key? key,
      required this.topicId,
      required this.creatorName,
      required this.topicName,
      required this.topicSubject})
      : super(key: key);

  @override
  State<TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  String fullName = "";
  @override
  void initState() {
    super.initState();
    gettingUserData();
    //gettingUserDataOffline();
  }

  gettingUserData() async {
    DatabaseService().getTopicCreator(widget.topicId).then((val) {
      setState(() {
        fullName = getName(val);
      });
    });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // print(widget.creatorName);
        // print(fullName);
        widget.creatorName != fullName
            ? nextScreen(
                context,
                TopicDetailPage(
                  creator: widget.creatorName,
                  topicId: widget.topicId,
                  topicName: widget.topicName,
                  topicSubject: widget.topicSubject,
                  isView: true,
                )) //Viewing lang
            : popUpDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading:
              // Icon(
              //   Icons.ac_unit,
              //   color: Theme.of(context).primaryColor,
              // ),
              CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.note_alt_rounded,
              color: Constants().customBackColor,
              size: 30,
            ),
            // Text(
            //   widget.topicSubject, //.substring(0, 1).toUpperCase(),
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       color: Constants().customBackColor,
            //       fontWeight: FontWeight.w600),
            // ),
          ),
          title: Text(
            widget.topicName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            "${Locales.string(context, "topic_created_by")}$fullName",
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Future<dynamic> popUpDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              widget.topicName,
              style: TextStyle(
                  color: Constants().customForeColor,
                  fontWeight: FontWeight.w600),
            ),
            content: const LocaleText("to_do"),
            actions: [
              IconButton(
                onPressed: () async {
                  //View
                  nextScreen(
                      context,
                      TopicDetailPage(
                        creator: widget.creatorName,
                        topicId: widget.topicId,
                        topicName: widget.topicName,
                        topicSubject: widget.topicSubject,
                        isView: true,
                      ));
                },
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Constants().customColor1,
                ),
              ),
              IconButton(
                onPressed: () async {
                  //Edit
                  nextScreen(
                      context,
                      TopicDetailPage(
                        creator: widget.creatorName,
                        topicId: widget.topicId,
                        topicName: widget.topicName,
                        topicSubject: widget.topicSubject,
                        isView: false,
                      ));
                },
                icon: Icon(
                  Icons.edit_note_outlined,
                  color: Constants().customColor1,
                ),
              ),
            ],
          );
        });
  }
}
