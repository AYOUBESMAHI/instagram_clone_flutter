import 'dart:io';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoLink;
  final bool isFile;

  const VideoPlayerWidget(this.videoLink, this.isFile, {super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool play = false;
  late VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    if (widget.isFile) {
      _videoController = VideoPlayerController.file(File(widget.videoLink))
        ..initialize().then((_) {
          setState(() {});
        });
      ;
    } else {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoLink))
            ..initialize().then((_) {
              setState(() {});
            });
    }
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        play = !play;
        if (play) {
          _videoController.play();
        } else {
          _videoController.pause();
        }
      }),
      child: Container(
        height: 300,
        width: 400,
        color: Colors.grey,
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
      ),
    );
  }
}
