import 'dart:io';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/pages/auth/login_page.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/database_service.dart';
import '../../shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets/widgets.dart';
import '../home_page.dart';

class UploadIdPage extends StatefulWidget {
  String email;
  UploadIdPage({Key? key, required this.email}) : super(key: key);

  @override
  State<UploadIdPage> createState() => _UploadIdPageState();
}

class _UploadIdPageState extends State<UploadIdPage> {
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
                        "Upload Id for verification",
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
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadImage() async {
    //addImageURL("https://avatars.githubusercontent.com/u/37553901?v=4");
    final path = "uploadedId/${widget.email}/${pickedFile!.name}";
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    if (urlDownload.isNotEmpty) {
      //addFileURL();
      addImageURL(urlDownload);
      showSnackbar(
          context, "Id uploaded successfully.", Constants().customColor2);
      await HelperFunctions.saveProfilePictureSF(urlDownload);
      await Future.delayed(const Duration(seconds: 3), () {});
      nextScreenReplace(context, LoginPage());
      //nextScreenReplace(context, HomePage());
    }
  }

  addImageURL(String uuurrrlll) {
    DatabaseService().uploadId(widget.email, uuurrrlll);
  }
}
