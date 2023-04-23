import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/helper/helper_function.dart';
import 'package:wachup_android_12/pages/chat_page.dart';
import 'package:wachup_android_12/pages/screens/reels_page_solo.dart';
import 'package:wachup_android_12/service/database_service.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../shared/constants_v2.dart';

class SearchReelsPage extends StatefulWidget {
  final String userName;
  final String email;
  final String accountType;
  const SearchReelsPage(
      {Key? key,
      required this.email,
      required this.userName,
      required this.accountType})
      : super(key: key);

  @override
  State<SearchReelsPage> createState() => _SearchReelsPageState();
}

class _SearchReelsPageState extends State<SearchReelsPage> {
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
          Locales.string(context, "reel_search"),
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
                        hintText: Locales.string(context, "reel_search_hint"),
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
              : reelList(),
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
          .searchReelByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  reelList() {
    print(searchSnapshot!.docs.length);
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              print('test2');
              return reelTile(
                  searchSnapshot!.docs[index]['reelCreatorName'],
                  searchSnapshot!.docs[index]['reelId'],
                  searchSnapshot!.docs[index]['reelName']);
            },
          )
        : Container();
  }

  Widget reelTile(String userName, String reelId, String reelName) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          reelName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
          Text(reelName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Creator: $userName"),
      trailing: InkWell(onTap: () async {
        Future.delayed(const Duration(seconds: 1), () {
          // nextScreen(
          //     context,
          //     ReelsPageSolo(
          //       accountType: widget.accountType,
          //       email: widget.email,
          //       userName: userName,
          //       reelId: reelId,
          //     ));
        });
      }),
    );
  }
}
