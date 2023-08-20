import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/Post.dart';
import '../../Models/User.dart';
import '../../Providers/Posts_Provider.dart';
import '../Home_Widgets/Posts_Widgets/MediasPost.dart';
import 'PostLikeAnimation.dart';

class PostMediaSection extends StatefulWidget {
  final Post post;
  final User currentUser;
  const PostMediaSection(this.post, this.currentUser, {super.key});

  @override
  State<PostMediaSection> createState() => _PostMediaSectionState();
}

class _PostMediaSectionState extends State<PostMediaSection> {
  bool isHeartAnimating = false;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostsProvider>(context, listen: false);
    return GestureDetector(
      onDoubleTap: () async {
        if (!postProvider.isLiked(widget.post, widget.currentUser.id)) {
          postProvider.likePost(widget.post, widget.currentUser);
          setState(() {
            isHeartAnimating = true;
          });
        }
      },
      onTap: () {
        setState(() {
          isHeartAnimating = false;
        });
      },
      child: Stack(
        children: [
          Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: MediasPost(widget.post.media),
          ),
          Opacity(
            opacity: isHeartAnimating ? 1 : 0,
            child: Center(
              child: PostLikeAnimation(
                  const Icon(
                    Icons.favorite,
                    size: 120,
                    color: Colors.white,
                  ),
                  const Duration(milliseconds: 800),
                  isHeartAnimating, () {
                setState(() {
                  isHeartAnimating = false;
                });
              }),
            ),
          ),
        ],
      ),
    );
  }
}
