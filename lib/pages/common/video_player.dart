import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../components/components.dart';
import '../../theme.dart';
import '../../models/models.dart';

class VideoPlayerPage extends StatelessWidget {
  final VideoEntity video;
  final File file;
  final VideoPlayerController controller;

  VideoPlayerPage({
    Key key,
    this.video,
    this.file,
    this.controller,
  })  : assert(video != null || file != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: WgTheme.blackDark,
        child: VideoPlayerWithControlBar(
          video: video,
          file: file,
          isAutoPlay: true,
          isFull: true,
          controller: controller,
        ),
      ),
    );
  }
}
