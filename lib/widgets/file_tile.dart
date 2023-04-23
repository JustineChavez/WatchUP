import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import '../service/database_service.dart';
import '../shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_locales/flutter_locales.dart';

class FileTile extends StatefulWidget {
  final String content;
  final String url;
  final String topicId;
  final String fileId;
  final bool isView;

  const FileTile(
      {Key? key,
      required this.topicId,
      required this.fileId,
      required this.content,
      required this.url,
      required this.isView})
      : super(key: key);

  @override
  State<FileTile> createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
  Map<int, double> downloadProgress = {};
  @override
  Widget build(BuildContext context) {
    double? progress = downloadProgress[0];
    return GestureDetector(
      onTap: () {
        // nextScreen(
        //     context,
        //     ChatPage(
        //       groupId: widget.groupId,
        //       groupName: widget.groupName,
        //       userName: widget.userName,
        //     ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              "F",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Constants().customBackColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            Locales.string(context, "file"),
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: progress != null
              ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Constants().customForeColor,
                )
              : Text(
                  widget.content,
                  style: const TextStyle(fontSize: 13),
                ),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
                icon: Icon(Icons.download_rounded,
                    color: Constants().customForeColor),
                onPressed: () => {downloadFile()}),
            IconButton(
                icon: Icon(Icons.delete_rounded,
                    color: Constants().customForeColor),
                onPressed: () => {
                      widget.isView
                          ? showSnackbar(
                              context,
                              Locales.string(context, "topic_no_download"),
                              Constants().customColor2)
                          : deleteFile()
                    })
          ]),
          // trailing: IconButton(
          //     icon: Icon(Icons.download_rounded,
          //         color: Constants().customForeColor),
          //     onPressed: () => {downloadFile()}),
        ),
      ),
    );
  }

  deleteFile() async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              Locales.string(context, "delete_title"),
              style: TextStyle(
                  color: Constants().customForeColor,
                  fontWeight: FontWeight.w600),
            ),
            content: Text(Locales.string(context, "delete_file")),
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
                      .deleteFileContent(widget.topicId, widget.fileId);
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

  downloadFile() async {
    final tempDir = await getApplicationSupportDirectory();
    final path = "${tempDir.path}/${widget.content}";
    await Dio().download(widget.url, path,
        onReceiveProgress: (received, total) {
      double progress = (received / total);

      setState(() {
        downloadProgress[0] = progress;
      });
    });

    if (widget.url.contains('.mp4')) {
      await GallerySaver.saveVideo(path, toDcim: true);
    } else if (widget.url.contains('.jpg')) {
      await GallerySaver.saveImage(path, toDcim: true);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Downloaded ${widget.content}')));
  }
}
