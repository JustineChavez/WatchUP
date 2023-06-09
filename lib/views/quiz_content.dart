import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:wachup_android_12/pages/screens/like_icon.dart';
import 'package:wachup_android_12/pages/screens/content_screen.dart';
import 'package:video_player/video_player.dart';

class QuizVideoContent extends StatefulWidget {
  final String? src;

  const QuizVideoContent({Key? key, this.src}) : super(key: key);

  @override
  _QuizVideoContentState createState() => _QuizVideoContentState();
}

class _QuizVideoContentState extends State<QuizVideoContent> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);
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
                onDoubleTap: () {
                  setState(() {
                    _liked = !_liked;
                  });
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
      ],
    );
  }
}
