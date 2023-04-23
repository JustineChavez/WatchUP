import 'dart:io';
import 'dart:math';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/widgets/widgets.dart';

import '../../service/database_service.dart';
import '../../shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class UploadReelPage extends StatefulWidget {
  final String email;
  final String name;
  UploadReelPage({Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  State<UploadReelPage> createState() => _UploadReelPageState();
}

class _UploadReelPageState extends State<UploadReelPage> {
  AuthService authService = AuthService();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  VideoPlayerController? _controller;

  String reelName = "";

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
                        Locales.string(context, "reels_title"),
                        style: TextStyle(
                            color: Constants().customBackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: "",
                        onChanged: (val) {
                          setState(() {
                            reelName = val;
                          });
                        },
                        style: TextStyle(
                            color: Constants().customBackColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      pickedFile != null
                          ? Container(
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Center(
                                    child: Text(
                                  pickedFile!.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                )),
                              ))
                          : const SizedBox(
                              height: 200,
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
                            Locales.string(context, "reels_select"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            selectFile();
                            //login();
                            //loginOffline();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
                            Locales.string(context, "reels_upload"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            uploadReel();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      uploadTask != null
                          ? buildUploadStatus(uploadTask!)
                          : Container()
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

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Center(
              child: Text(
                '$percentage %',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            return Container();
          }
        },
      );

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Constants().customColor2,
      elevation: 0,
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
      _controller = VideoPlayerController.file(File(pickedFile!.path!));
    });
  }

  Future uploadReel() async {
    if (reelName.isEmpty) {
      showSnackbar(context, "Please input a title for your reel.",
          Constants().customColor2);
      return;
    }
    final path = "reels/${widget.email}/${pickedFile!.name}";
    final file = File(pickedFile!.path!);
    //print(path);
    //print(file);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    setState(() {});

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    if (urlDownload.isNotEmpty) {
      addReel(urlDownload);
      showSnackbar(
          context, "Reels successfully uploaded.", Constants().customColor2);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
    }
    //print('Download Link: $urlDownload');
  }

  addReel(String uuurrrlll) {
    //print(widget.topicId);
    DatabaseService()
        .createReels(widget.email, widget.name, reelName, uuurrrlll);
  }
}
