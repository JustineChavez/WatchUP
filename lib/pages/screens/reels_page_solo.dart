// import 'package:card_swiper/card_swiper.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:wachup_android_12/pages/upload/upload_reel.dart';
// import 'package:wachup_android_12/shared/constants.dart';
// import '../../service/database_service.dart';
// import '../../shared/drawer.dart';
// import '../../widgets/widgets.dart';
// import '../search_page.dart';
// import '../search_page_reels.dart';
// import 'content_screen.dart';

// class ReelsPageSolo extends StatefulWidget {
//   String userName;
//   String email;
//   String accountType;
//   String reelId;
//   ReelsPageSolo(
//       {Key? key,
//       required this.email,
//       required this.userName,
//       required this.accountType,
//       required this.reelId})
//       : super(key: key);

//   @override
//   State<ReelsPageSolo> createState() => _ReelsPageSolo();
// }

// class _ReelsPageSolo extends State<ReelsPageSolo> {
//   Stream? reels;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       //backgroundColor: Theme.of(context).primaryColor,
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: () {
//                 //nextScreen(context, const SearchPage());
//                 widget.accountType == "Teacher"
//                     ?
//                     //showSnackbar(context, "Hi Teacher.", Constants().customColor2)
//                     nextScreen(
//                         context,
//                         UploadReelPage(
//                           email: widget.email,
//                           name: widget.userName,
//                         ))
//                     : showSnackbar(
//                         context,
//                         "Students are not allowed to add reels.",
//                         Constants().customColor2);
//               },
//               icon: const Icon(
//                 Icons.video_call_rounded,
//               )),
//         ],
//         backgroundColor: Constants().customBackColor.withOpacity(0.3),
//         elevation: 0,
//         title: const Text(
//           "WatchUP Shorts",
//           style: TextStyle(
//               fontSize: 23, fontWeight: FontWeight.w600, color: Colors.black87),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black87),
//       ),
//       // drawer: CustomDrawer(
//       //   currentPage: 5, //Groups,
//       //   currentUserName: widget.userName,
//       //   currentEmail: widget.email,
//       //   currentAccountType: widget.accountType,
//       // ),
//       body: SafeArea(
//         top: false,
//         left: false,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 24),
//           child: Container(
//             child: Stack(
//               children: [
//                 //We need swiper for every content
//                 Swiper(
//                   itemBuilder: (BuildContext context, int index) {
//                     return ContentScreen(
//                       src: widget.reelId,
//                       accountType: widget.accountType,
//                       email: widget.email,
//                       userName: widget.userName,
//                     );
//                   },
//                   itemCount: 1,
//                   scrollDirection: Axis.vertical,
//                 ),
//                 Container(
//                   color: Constants().customBackColor.withOpacity(0.3),
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
