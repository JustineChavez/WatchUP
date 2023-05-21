import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/helper/helper_function.dart';
import 'package:wachup_android_12/service/database_service.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../shared/constants_v2.dart';

class SearchPageTopic extends StatefulWidget {
  const SearchPageTopic({Key? key}) : super(key: key);

  @override
  State<SearchPageTopic> createState() => _SearchPageStateTopic();
}

class _SearchPageStateTopic extends State<SearchPageTopic> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          Locales.string(context, "topic_search"),
          style: TextStyle(
              fontSize: 20,
              color: Constants().customBackColor,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Constants().customBackColor),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Locales.string(context, "topic_search_hint"),
                        hintStyle: TextStyle(
                            color: Constants().customBackColor, fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Constants().customBackColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: Icon(
                      Icons.search_outlined,
                      color: Constants().customBackColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : topicList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          //.searchTopicByName(searchController.text)
          .searchTopics()
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  topicList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              //print(searchSnapshot!.docs[index]['topicName'].toString());
              if (searchSnapshot!.docs[index]['topicName']
                  .toString()
                  .toLowerCase()
                  //.startsWith(searchController.text.toLowerCase())
                  .contains(searchController.text.toLowerCase())) {
                return topicTile(
                    userName,
                    searchSnapshot!.docs[index]['topicId'],
                    searchSnapshot!.docs[index]['topicName'],
                    searchSnapshot!.docs[index]['creator'],
                    searchSnapshot!.docs[index]['topicSubject']);
              }
            },
          )
        : Container();
  }

  addedOrNot(String userName, String topicId, String topicName, String creator,
      String topicSubject) async {
    await DatabaseService(uid: user!.uid)
        .isTopicAdded(topicName, topicId, userName, topicSubject)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget topicTile(String userName, String topicId, String topicName,
      String creator, String topicSubject) {
    // function to check whether user already exists in group
    addedOrNot(userName, topicId, topicName, creator, topicSubject);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          topicName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
          Text(topicName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Creator: ${getName(creator)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleTopicAdd(topicId, userName, topicName, topicSubject);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackbar(context, Constants().customColor1,
                Locales.string(context, "topic_join_success"));
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackbar(context, Constants().customColor2,
                  "${Locales.string(context, "topic_join_as")} $topicName");
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants().customForeColor,
                  border:
                      Border.all(color: Constants().customBackColor, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  Locales.string(context, "topic_joined"),
                  style: TextStyle(color: Constants().customBackColor),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(Locales.string(context, "topic_join"),
                    style: TextStyle(color: Constants().customBackColor)),
              ),
      ),
    );
  }
}
