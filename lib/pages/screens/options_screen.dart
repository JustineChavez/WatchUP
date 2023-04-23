import 'package:flutter/material.dart';
import 'package:wachup_android_12/pages/screens/attachment_page.dart';
import 'package:wachup_android_12/pages/screens/comment_page.dart';
import 'package:wachup_android_12/pages/screens/like_page.dart';
import 'package:wachup_android_12/widgets/widgets.dart';

import '../../shared/constants.dart';

class OptionScreen extends StatefulWidget {
  final String? reelVideo;
  final String? reelId;
  final String? reelCreator;
  final String? reelCreatorName;
  final int? reelLikes;
  final String? reelName;

  final String? userEmail;
  final String? userName;

  const OptionScreen(
      {Key? key,
      required this.reelVideo,
      required this.reelId,
      required this.reelCreator,
      required this.reelCreatorName,
      required this.reelLikes,
      required this.reelName,
      required this.userEmail,
      required this.userName})
      : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text(widget.reelCreatorName!),
                      SizedBox(width: 25),
                      //Icon(Icons.verified, size: 15),
                      SizedBox(width: 25),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     'Follow',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Text(widget.reelName!),
                  SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.music_note,
                  //       size: 15,
                  //     ),
                  //     Text('Original Audio - some music track--'),
                  //   ],
                  // ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      //popUpDialog(context);
                      nextScreen(
                          context,
                          ReelsLikePage(
                            reelId: widget.reelId,
                            reelName: widget.reelName,
                            userName: widget.userName,
                          ));
                    },
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Constants().customForeColor,
                      size: 25,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      //popUpDialog(context);
                      nextScreen(
                          context,
                          ReelsCommentPage(
                            reelId: widget.reelId,
                            reelName: widget.reelName,
                            userName: widget.userName,
                          ));
                    },
                    child: Icon(
                      Icons.comment_rounded,
                      color: Constants().customForeColor,
                      size: 25,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      //popUpDialog(context);
                      widget.userEmail == widget.reelCreator
                          ? nextScreen(
                              context,
                              AttachmentPage(
                                creator: widget.reelCreator,
                                reelName: widget.reelName,
                                reelId: widget.reelId,
                                isView: false,
                              ))
                          : nextScreen(
                              context,
                              AttachmentPage(
                                creator: widget.reelCreator,
                                reelName: widget.reelName,
                                reelId: widget.reelId,
                                isView: true,
                              ));
                    },
                    child: Icon(
                      Icons.attach_file,
                      color: Constants().customForeColor,
                      size: 25,
                    ),
                  ),
                  SizedBox(height: 50),
                  widget.userEmail == widget.reelCreator
                      ? Icon(Icons.delete)
                      : SizedBox(height: 50),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
