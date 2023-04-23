import 'dart:io';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../service/database_service.dart';
import '../../shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/widgets.dart';

class ViewVideoPage extends StatefulWidget {
  final String content;
  final String url;
  final String topicId;
  final String fileId;
  final bool isView;

  ViewVideoPage(
      {Key? key,
      required this.topicId,
      required this.fileId,
      required this.content,
      required this.url,
      required this.isView})
      : super(key: key);

  @override
  State<ViewVideoPage> createState() => _ViewVideoPageState();
}

class _ViewVideoPageState extends State<ViewVideoPage> {
  Map<int, double> downloadProgress = {};
  AuthService authService = AuthService();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.url);
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      autoInitialize: true,

      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(
      //       onTap: () => debugPrint('Option 1 pressed!'),
      //       iconData: Icons.chat,
      //       title: 'Option 1',
      //     ),
      //     OptionItem(
      //       onTap: () => debugPrint('Option 2 pressed!'),
      //       iconData: Icons.share,
      //       title: 'Option 2',
      //     ),
      //   ];
      // },
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: chewieController != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Chewie(
                controller: chewieController!,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  SingleChildScrollView buildContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  //height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Constants().customBackColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.content,
                        style: TextStyle(
                            color: Constants().customBackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: chewieController != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Chewie(
                                  controller: chewieController!,
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants().customColor2,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text(
                            Locales.string(context, "topic_download_image"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            downloadVideo();
                            //selectFile();
                            //login();
                            //loginOffline();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              downloadVideo();
            },
            icon: const Icon(
              Icons.download_rounded,
            )),
        IconButton(
            onPressed: () {
              widget.isView
                  ? showSnackbar(
                      context,
                      Locales.string(context, "topic_no_download"),
                      Constants().customColor2)
                  : deleteVideo();
            },
            icon: const Icon(
              Icons.delete_rounded,
            ))
      ],
      backgroundColor: Constants().customColor2,
      title: Text(widget.content),
      elevation: 0,
    );
  }

  deleteVideo() async {
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
            content: Text(Locales.string(context, "delete_video")),
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
                      .deleteVideoContent(widget.topicId, widget.fileId);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted ${widget.content}')));
                  Navigator.pop(context);
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
  }

  downloadVideo() async {
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
