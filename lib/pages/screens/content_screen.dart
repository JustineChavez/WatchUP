import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/pages/screens/like_icon.dart';
import 'package:wachup_android_12/pages/screens/content_screen.dart';
import 'package:video_player/video_player.dart';

import '../../service/database_service.dart';
import 'options_screen.dart';

class ContentScreen extends StatefulWidget {
  final String? reelVideo;
  final String? reelId;
  final String? reelCreator;
  final String? reelCreatorName;
  final int? reelLikes;
  final String? reelName;

  final String? userEmail;
  final String? userName;

  const ContentScreen(
      {Key? key,
      required this.reelVideo,
      required this.reelId,
      required this.reelCreator,
      required this.reelCreatorName,
      required this.reelLikes,
      required this.reelName,
      required this.userEmail,
      required this.userName})
      : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  //String? videoURL;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;
  @override
  void initState() {
    //gettingReelVideo();
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.reelVideo!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  // setState(() {
                  //   _liked = !_liked;
                  // });

                  if (_chewieController!.isPlaying) {
                    _chewieController!.pause();
                  } else {
                    // If the video is paused, play it.
                    _chewieController!.play();
                  }
                },
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading...')
                ],
              ),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        OptionScreen(
            reelVideo: widget.reelVideo,
            reelId: widget.reelId,
            reelCreator: widget.reelCreator,
            reelCreatorName: widget.reelCreatorName,
            reelLikes: widget.reelLikes,
            reelName: widget.reelName,
            userEmail: widget.userEmail,
            userName: widget.userName)
      ],
    );
  }
}
