import 'dart:io';
import 'dart:math';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../service/database_service.dart';
import '../../shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFilePage extends StatefulWidget {
  String topicId;
  UploadFilePage({Key? key, required this.topicId}) : super(key: key);

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  AuthService authService = AuthService();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? url;

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
                        Locales.string(context, "topic_upload_file"),
                        style: TextStyle(
                            color: Constants().customBackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
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
                            Locales.string(context, "topic_select_file"),
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
                            Locales.string(context, "topic_button_upload"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            //testAddFile();
                            uploadFile();
                            //addFileURL();
                            //addFile();
                            //login();
                            //loginOffline();
                          },
                        ),
                      ),
                      SizedBox(height: 10),
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
    });
  }

  Future uploadFile() async {
    final path = "files/${widget.topicId}/${pickedFile!.name}";
    final file = File(pickedFile!.path!);
    //print(path);
    //print(file);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    setState(() {});

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    if (urlDownload.isNotEmpty) {
      setState(() {
        url = urlDownload;
      });
      //addFileURL();
      addFileURL(urlDownload);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
    }
    print('Download Link: $urlDownload');
  }

  addFileURL(String uuurrrlll) {
    Map<String, dynamic> fileContentMap = {
      "id": "",
      "content": pickedFile!.name,
      "content2": uuurrrlll,
      "time": DateTime.now().millisecondsSinceEpoch,
    };
    //print(widget.topicId);
    DatabaseService().addFileContent(widget.topicId, fileContentMap);
  }

  addFile() async {
    if (pickedFile!.name.isNotEmpty) {
      Map<String, dynamic> fileContentMap = {
        "id": "",
        "content": pickedFile!.name,
        "content2": "files/${widget.topicId}/${pickedFile!.name}",
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      //print(widget.topicId);
      DatabaseService().addFileContent(widget.topicId, fileContentMap);
    }
  }
}
