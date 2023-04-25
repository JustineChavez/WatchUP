import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/models/reel_model.dart';
import 'package:wachup_android_12/pages/upload/upload_reel.dart';
import 'package:wachup_android_12/shared/constants.dart';
import '../../helper/helper_function.dart';
import '../../services/database.dart';
import '../../shared/drawer.dart';
import '../../widgets/widgets.dart';
import '../search_page.dart';
import '../search_page_reels.dart';
import 'content_screen.dart';

class ReelsPage extends StatefulWidget {
  ReelsPage({Key? key}) : super(key: key);

  // List<String> videos = [
  //   'https://firebasestorage.googleapis.com/v0/b/test-flutter-login-bcb8f.appspot.com/o/videos%2FGY1mHGGhDXyj1V12UUsK%2FVID_20230416_120316.mp4?alt=media&token=4aea14f0-7d1e-449d-9fb0-dba734a894f1',
  //   'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
  //   'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
  //   'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
  //   'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
  //   'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
  //   'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
  //   'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  // ];
  List<String> videos = [];

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  String userName = "";
  String email = "";
  String accountType = "";
  String profilePictureURL =
      "https://avatars.githubusercontent.com/u/37553901?v=4";
  dynamic reelsStream;
  DatabaseService databaseService = new DatabaseService();

  Widget reelList() {
    return SafeArea(
      top: false,
      left: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Container(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: reelsStream,
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    snapshot.data!.docs;

                return Stack(
                  children: [
                    //We need swiper for every content
                    Swiper(
                      itemBuilder: (_, index) {
                        final doc = docs[index];
                        final reelCreator = doc["reelCreator"];
                        final reelCreatorName = doc["reelCreatorName"];
                        final reelLikes = doc["reelLikes"];
                        final reelName = doc["reelName"];
                        final reelVideo = doc["reelVideo"];
                        final reelId = doc["reelId"];

                        return ContentScreen(
                          reelVideo: reelVideo,
                          reelCreator: reelCreator,
                          reelCreatorName: reelCreatorName,
                          reelLikes: reelLikes,
                          reelId: reelId,
                          reelName: reelName,
                          userEmail: email,
                          userName: userName,
                        );
                      },
                      itemCount: docs.length,
                      scrollDirection: Axis.vertical,
                    ),
                    Container(
                      color: Constants().customBackColor.withOpacity(0.3),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    databaseService.getReelsData().then((val) {
      setState(() {
        reelsStream = val;
      });
    });
    gettingUserData();
    super.initState();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUserAccountTypeSF().then((val) {
      setState(() {
        accountType = val!;
      });
      print(accountType);
    });
    await HelperFunctions.getProfilePictureSF().then((val) {
      setState(() {
        profilePictureURL = val!;
      });
      print(accountType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        //backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  accountType == "Teacher"
                      ? nextScreen(
                          context,
                          UploadReelPage(
                            email: email,
                            name: userName,
                          ))
                      : showSnackbar(
                          context,
                          "Students are not allowed to add reels.",
                          Constants().customColor2);
                },
                icon: const Icon(
                  Icons.video_call_rounded,
                )),
          ],
          backgroundColor: Constants().customBackColor.withOpacity(0.3),
          elevation: 0,
          title: const Text(
            "Reels",
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        drawer: CustomDrawer(
          currentPage: 5, //Groups,
          currentUserName: userName,
          currentEmail: email,
          currentAccountType: accountType,
          ppURL: profilePictureURL,
        ),
        body: reelList());
  }
}
