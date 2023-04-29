import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/pages/screens/reels_page.dart';
import 'package:wachup_android_12/pages/topic_page.dart';
import 'package:wachup_android_12/shared/constants_v2.dart';
import 'package:wachup_android_12/shared/localization.dart';
import 'package:wachup_android_12/views/home.dart';

import '../pages/auth/login_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/quiz/quiz_screen.dart';
import '../widgets/widgets.dart';
import 'constants.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class CustomDrawer extends Drawer {
  final currentPage;
  final currentUserName;
  final currentEmail;
  final currentAccountType;
  final ppURL;

  const CustomDrawer(
      {required this.currentPage,
      required this.currentUserName,
      required this.currentEmail,
      required this.currentAccountType,
      required this.ppURL});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Drawer(
        child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 50),
      children: <Widget>[
        // Icon(
        //   Icons.account_circle_outlined,
        //   size: 120,
        //   color: Theme.of(context).primaryColor,
        // ),
        ProfilePicture(
            name: currentUserName,
            role: currentAccountType,
            radius: 100,
            fontsize: 21,
            tooltip: true,
            img: ppURL),
        const SizedBox(
          height: 15,
        ),
        Text(
          currentUserName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        const SizedBox(
          height: 30,
        ),
        const Divider(
          height: 2,
        ),
        ListTile(
          onTap: () {
            print(currentPage);
            if (currentPage != 5) {
              nextScreen(context, ReelsPage());
              //ReelsPage(
              //   userName: currentUserName,
              //   email: currentEmail,
              //   accountType: currentAccountType,
              //   ppURL: ppURL,
              // ));
            }
          },
          selected: currentPage == 5 ? true : false,
          selectedColor: Theme.of(context).primaryColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.video_library_rounded),
          title: Text(
            //Locales.string(context, "topics_title"),
            "Reels",
            style: TextStyle(
                color: Constants().customForeColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        //Topics
        ListTile(
          onTap: () {
            if (currentPage != 1) {
              nextScreen(context, TopicPage());
              //   userName: currentUserName,
              //   email: currentEmail,
              //   accountType: currentAccountType,
              //   ppURL: ppURL,
              // ));
            }
          },
          selected: currentPage == 1 ? true : false,
          selectedColor: Theme.of(context).primaryColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.note_outlined),
          title: Text(
            Locales.string(context, "topics_title"),
            style: TextStyle(
                color: Constants().customForeColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        //Group
        ListTile(
          onTap: () {
            if (currentPage != 2) {
              nextScreen(context, const HomePage());
            }
          },
          selected: currentPage == 2 ? true : false,
          selectedColor: Theme.of(context).primaryColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.group_outlined),
          title: Text(
            Locales.string(context, "groups_title"),
            style: TextStyle(
                color: Constants().customForeColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        // Profile
        ListTile(
          onTap: () {
            if (currentPage != 3) {
              nextScreenReplace(
                  context,
                  ProfilePage(
                    userName: currentUserName,
                    email: currentEmail,
                    accountType: currentAccountType,
                    ppURL: ppURL,
                  ));
            }
          },
          selected: currentPage == 3 ? true : false,
          selectedColor: Theme.of(context).primaryColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.account_circle_outlined),
          title: Text(
            Locales.string(context, "profile_title"),
            style: TextStyle(
                color: Constants().customForeColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        //Games
        // ListTile(
        //   onTap: () {
        //     if (currentPage != 4) {
        //       //nextScreen(context, QuizScreen());
        //       nextScreen(context, Quiz());
        //     }
        //   },
        //   selected: currentPage == 4 ? true : false,
        //   selectedColor: Theme.of(context).primaryColor,
        //   contentPadding:
        //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //   leading: const Icon(Icons.smart_toy_outlined),
        //   title: Text(
        //     Locales.string(context, "games_title"),
        //     style: TextStyle(
        //         color: Constants().customForeColor,
        //         fontWeight: FontWeight.w600),
        //   ),
        // ),
        //Localization
        ListTile(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LanguagePage()),
            );
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.language_outlined),
          title: Text(
            Locales.string(context, "language_title"),
            style: TextStyle(
                color: Constants().customForeColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        //Logout
        ListTile(
          onTap: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      Locales.string(context, "logout_title"),
                      style: TextStyle(
                          color: Constants().customForeColor,
                          fontWeight: FontWeight.w600),
                    ),
                    content: Text(Locales.string(context, "logout_question")),
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
                          await authService.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false);
                        },
                        icon: Icon(
                          Icons.done_outline,
                          color: Constants().customColor1,
                        ),
                      ),
                    ],
                  );
                });
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.logout_outlined),
          title: Text(
            Locales.string(context, "logout_title"),
            style: TextStyle(
                color: Constants().customForeColor,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    ));
  }
}
