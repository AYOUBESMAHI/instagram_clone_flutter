import 'package:flutter/material.dart';
//Widget
import '../../SinglePost_Widgets/VideoPlayer_Widget.dart';

class MediasPost extends StatelessWidget {
  final List<Map<String, String>> media;
  const MediasPost(this.media, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, i) {
        if (media[i]["type"] == "image") {
          return Image.network(
            media[i]["media"]!,
            fit: BoxFit.cover,
          );
        } else {
          return VideoPlayerWidget(media[i]["media"]!, false);
        }
      },
      itemCount: media.length,
    );
  }
}
