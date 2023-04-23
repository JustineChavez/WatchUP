import 'dart:io';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../service/database_service.dart';
import '../../shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImagePage extends StatefulWidget {
  String topicId;
  UploadImagePage({Key? key, required this.topicId}) : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
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
                        Locales.string(context, "topic_upload_image"),
                        style: TextStyle(
                            color: Constants().customBackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      pickedFile != null
                          ? Center(
                              child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 200,
                                child: Image.file(
                                  File(pickedFile!.path!),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                          : const SizedBox(
                              height: 180,
                            ),
                      const SizedBox(
                        height: 20,
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
                            Locales.string(context, "topic_select_image"),
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
                            uploadImage();
                            //addImage();
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
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadImage() async {
    final path = "images/${widget.topicId}/${pickedFile!.name}";
    final file = File(pickedFile!.path!);
    //print(path);
    //print(file);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    if (urlDownload.isNotEmpty) {
      //addFileURL();
      addImageURL(urlDownload);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
    }
    //print('Download Link: $urlDownload');
  }

  addImageURL(String uuurrrlll) {
    Map<String, dynamic> fileContentMap = {
      "id": "",
      "content": pickedFile!.name,
      "content2": uuurrrlll,
      "time": DateTime.now().millisecondsSinceEpoch,
    };
    //print(widget.topicId);
    DatabaseService().addImageContent(widget.topicId, fileContentMap);
  }

  addImage() async {
    if (pickedFile!.name.isNotEmpty) {
      Map<String, dynamic> fileContentMap = {
        "id": "",
        "content": pickedFile!.name,
        "content2": "images/${widget.topicId}/${pickedFile!.name}",
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      //print(widget.topicId);
      DatabaseService().addImageContent(widget.topicId, fileContentMap);
    }
  }
}
