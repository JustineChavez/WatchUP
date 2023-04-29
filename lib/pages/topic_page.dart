import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/pages/search_page_topics.dart';
import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import '../service/database_service.dart';
import '../shared/constants.dart';
import '../shared/drawer.dart';
import '../widgets/topic_tile.dart';
import '../widgets/widgets.dart';

class TopicPage extends StatefulWidget {
  // String userName;
  // String email;
  // String accountType;
  // String ppURL;
  TopicPage({
    Key? key,
    // required this.email,
    // required this.userName,
    // required this.accountType,
    // required this.ppURL
  }) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

// string manipulation
String getId(String res) {
  return res.substring(0, res.indexOf("_"));
}

String getName(String res) {
  String fHalf = res.substring(res.indexOf("_") + 1);
  return fHalf.substring(0, fHalf.indexOf("_"));
}

String getSubject(String res) {
  String fHalf = res.substring(res.indexOf("_") + 1);
  return fHalf.substring(fHalf.indexOf("_") + 1);
}

class _TopicPageState extends State<TopicPage> {
  String userName = "";
  String email = "";
  String accountType = "";
  String profilePictureURL =
      "https://avatars.githubusercontent.com/u/37553901?v=4";

  AuthService authService = AuthService();
  Stream? topics;
  bool _isLoading = false;
  String topicName = "";
  String topicSubject = "";
  String topicAbout = "";

  @override
  void initState() {
    gettingUserData();
    super.initState();
    //gettingUserDataOffline();
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
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getAllTopics()
        .then((snapshot) {
      setState(() {
        topics = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: CustomDrawer(
        currentPage: 1, //Topic,
        currentUserName: userName,
        currentEmail: email,
        currentAccountType: accountType,
        ppURL: profilePictureURL,
      ),
      body: topicList(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        accountType == "Teacher"
            ? popUpDialog(context)
            : popUpDialogStudent(context);
      },
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.post_add_outlined,
        color: Constants().customBackColor,
        size: 30,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              nextScreen(context, const SearchPageTopic());
            },
            icon: const Icon(
              Icons.search_outlined,
            ))
      ],
      elevation: 0,
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        Locales.string(context, "topics_title"),
        style: TextStyle(
            color: Constants().customBackColor,
            fontWeight: FontWeight.w600,
            fontSize: 20),
      ),
    );
  }

  popUpDialogStudent(BuildContext context) {
    showSnackbar(context, Locales.string(context, "topic_not_allowed"),
        Constants().customColor2);
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                Locales.string(context, "topic_create"),
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : Column(
                          children: [
                            TextField(
                              onChanged: (val) {
                                setState(() {
                                  topicName = val;
                                });
                              },
                              style:
                                  TextStyle(color: Constants().customForeColor),
                              decoration: textInputDecoration.copyWith(
                                  labelText:
                                      Locales.string(context, "topic_name"),
                                  prefixIcon: Icon(
                                    Icons.note_rounded,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (val) {
                                setState(() {
                                  topicSubject = val;
                                });
                              },
                              style:
                                  TextStyle(color: Constants().customForeColor),
                              decoration: textInputDecoration.copyWith(
                                  labelText:
                                      Locales.string(context, "topic_subject"),
                                  prefixIcon: Icon(
                                    Icons.book_rounded,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (val) {
                                setState(() {
                                  topicAbout = val;
                                });
                              },
                              style:
                                  TextStyle(color: Constants().customForeColor),
                              decoration: textInputDecoration.copyWith(
                                  labelText:
                                      Locales.string(context, "topic_about"),
                                  prefixIcon: Icon(
                                    Icons.info_outline_rounded,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ),
                          ],
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: Text(Locales.string(context, "cancel_button")),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (topicName != "" &&
                        topicSubject != "" &&
                        topicAbout != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createTopic(FirebaseAuth.instance.currentUser!.uid,
                              userName, topicName, topicSubject, topicAbout)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(context, Constants().customColor3, " z");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: Text(Locales.string(context, "create_button")),
                )
              ],
            );
          }));
        });
  }

  InputDecoration customTextDeco(BuildContext context) {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants().customColor1),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20)));
  }

  topicList() {
    return StreamBuilder(
      stream: topics,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['topics'] != null) {
            if (snapshot.data['topics'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['topics'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['topics'].length - index - 1;
                  return TopicTile(
                      currentUserName: userName,
                      topicId: getId(snapshot.data['topics'][reverseIndex]),
                      creatorName: snapshot.data['fullName'],
                      topicName: getName(snapshot.data['topics'][reverseIndex]),
                      topicSubject:
                          getSubject(snapshot.data['topics'][reverseIndex]));
                },
              );
            } else {
              return noTopicWidget();
            }
          } else {
            return noTopicWidget();
          }
        } else {
          //return noTopicWidget();
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noTopicWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              accountType == "Teacher"
                  ? popUpDialog(context)
                  : popUpDialogStudent(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Constants().customForeColor,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            Locales.string(context, "topic_no"),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
