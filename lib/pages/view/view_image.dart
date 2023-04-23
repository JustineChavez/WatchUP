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

import '../../widgets/widgets.dart';

class ViewImagePage extends StatefulWidget {
  final String content;
  final String url;
  final String topicId;
  final String fileId;
  final bool isView;
  ViewImagePage(
      {Key? key,
      required this.topicId,
      required this.fileId,
      required this.content,
      required this.url,
      required this.isView})
      : super(key: key);

  @override
  State<ViewImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage> {
  Map<int, double> downloadProgress = {};
  AuthService authService = AuthService();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().customColor2,
      appBar: buildAppBar(context),
      body: buildContainer(context),
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
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 200,
                          child: Image.network(
                            //File(pickedFile!.path!),
                            widget.url,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
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
                            downloadImage();
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
        backgroundColor: Constants().customColor2,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                widget.isView
                    ? showSnackbar(
                        context,
                        Locales.string(context, "topic_no_download"),
                        Constants().customColor2)
                    : deleteImage();
              },
              icon: const Icon(
                Icons.delete_rounded,
              ))
        ]);
  }

  deleteImage() async {
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
            content: Text(Locales.string(context, "delete_image")),
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
                      .deleteImageContent(widget.topicId, widget.fileId);
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  downloadImage() async {
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
