import 'package:flutter/material.dart';
import 'package:wachup_android_12/pages/view/view_image.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../shared/constants.dart';

class ImageTile extends StatefulWidget {
  final String content;
  final String url;
  final String topicId;
  final String fileId;
  final bool isView;

  const ImageTile(
      {Key? key,
      required this.topicId,
      required this.fileId,
      required this.content,
      required this.url,
      required this.isView})
      : super(key: key);

  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ViewImagePage(
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
              "I",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Constants().customBackColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            Locales.string(context, "image"),
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
