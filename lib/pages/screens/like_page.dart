import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/service/database_service.dart';
import 'package:wachup_android_12/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:wachup_android_12/shared/constants.dart';

class ReelsLikePage extends StatefulWidget {
  final String? reelId;
  final String? reelName;
  final String? userName;

  const ReelsLikePage(
      {Key? key,
      required this.reelId,
      required this.reelName,
      required this.userName})
      : super(key: key);

  @override
  State<ReelsLikePage> createState() => _ReelsLikePageState();
}

class _ReelsLikePageState extends State<ReelsLikePage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getReelLikes();
    super.initState();
  }

  getReelLikes() {
    DatabaseService().getLikes(widget.reelId!).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.reelName!,
            style: TextStyle(
                color: Constants().customBackColor,
                fontWeight: FontWeight.w600,
                fontSize: 20)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          likes(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Constants().customForeColor,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: TextStyle(color: Constants().customBackColor),
                  decoration: InputDecoration(
                    hintText: "Give a like!",
                    hintStyle: TextStyle(
                        color: Constants().customBackColor, fontSize: 16),
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    addLike();
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
                      Icons.thumb_up_sharp,
                      color: Constants().customBackColor,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  likes() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['like'],
                      sender: snapshot.data.docs[index]['liker'],
                      sentByMe: true);
                },
              )
            : Container();
      },
    );
  }

  addLike() {
    Map<String, dynamic> reelCommentMap = {
      "like": "I like this reel!",
      "liker": widget.userName,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    DatabaseService().addLikes(widget.reelId!, reelCommentMap);
  }
}
