import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import '../pages/view/view_video.dart';
import '../shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_locales/flutter_locales.dart';

class VideoTile extends StatefulWidget {
  final String content;
  final String url;
  final String topicId;
  final String fileId;
  final bool isView;

  const VideoTile(
      {Key? key,
      required this.topicId,
      required this.fileId,
      required this.content,
      required this.url,
      required this.isView})
      : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ViewVideoPage(
              topicId: widget.topicId,
              fileId: widget.fileId,
              content: widget.content,
              url: widget.url,
              isView: widget.isView,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              "V",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Constants().customBackColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            Locales.string(context, "video"),
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            widget.content,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
