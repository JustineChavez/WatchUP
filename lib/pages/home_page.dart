import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/pages/search_page.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:wachup_android_12/service/database_service.dart';
import 'package:wachup_android_12/widgets/group_tile.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';
import '../shared/constants.dart';
import '../shared/constants_v2.dart';
import '../shared/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  String accountType = "";
  String profilePictureURL =
      "https://avatars.githubusercontent.com/u/37553901?v=4";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
    //gettingUserDataOffline();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
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
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  gettingUserDataOffline() async {
    setState(() {
      email = "TestEmail@gmail.com";
    });
    setState(() {
      userName = "Justine Chavez";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: CustomDrawer(
        currentPage: 2, //Groups,
        currentUserName: userName,
        currentEmail: email,
        currentAccountType: accountType,
        ppURL: profilePictureURL,
      ),
      body: groupList(),
      floatingActionButton: addNewGroup(context),
    );
  }

  FloatingActionButton addNewGroup(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        popUpDialog(context);
      },
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.group_add_outlined,
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
              nextScreen(context, const SearchPage());
            },
            icon: const Icon(
              Icons.search,
            ))
      ],
      elevation: 0,
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        Locales.string(context, "groups_title"),
        style: TextStyle(
            color: Constants().customBackColor,
            fontWeight: FontWeight.w600,
            fontSize: 20),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text(
                Locales.string(context, "group_create"),
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: TextStyle(color: Constants().customForeColor),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants().customColor1),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
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
                  child: LocaleText("cancel_button"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(context, Constants().customColor3, " z");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: LocaleText("create_button"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
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
            Locales.string(context, "group_no"),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
