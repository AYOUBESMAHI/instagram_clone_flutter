import 'package:flutter/material.dart';
import 'package:intagram/Widgets/SinglePost_Widgets/PostLikeAnimation.dart';
import 'package:provider/provider.dart';

import '../../Models/Post.dart';
import '../../Models/User.dart';
import '../../Providers/Posts_Provider.dart';
import '../../Providers/User_Provider.dart';

class LikeCommentSaveSection extends StatefulWidget {
  final Post post;
  final User currentUser;
  final Function commentsbar;
  const LikeCommentSaveSection(this.post, this.currentUser, this.commentsbar,
      {super.key});

  @override
  State<LikeCommentSaveSection> createState() => _LikeCommentSaveSectionState();
}

class _LikeCommentSaveSectionState extends State<LikeCommentSaveSection> {
  bool isHeartAnimating = false;

  @override
  Widget build(BuildContext context) {
    PostsProvider postsProvider = Provider.of<PostsProvider>(context);
    if (!postsProvider.isLiked(widget.post, widget.currentUser.id)) {
      isHeartAnimating = false;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        PostLikeAnimation(
            IconButton(
              onPressed: () {
                if (!postsProvider.isLiked(
                    widget.post, widget.currentUser.id)) {
                  setState(() {
                    isHeartAnimating = true;
                  });
                }
                postsProvider.likePost(widget.post, widget.currentUser);
              },
              icon: postsProvider.isLiked(widget.post, widget.currentUser.id)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
            ),
            const Duration(milliseconds: 700),
            isHeartAnimating,
            null),
        IconButton(
          onPressed: () {
            widget.commentsbar(context, postsProvider, widget.currentUser);
          },
          icon: postsProvider.isCommented(widget.post, widget.currentUser.id)
              ? const Icon(
                  Icons.chat_bubble,
                  color: Colors.blueAccent,
                )
              : const Icon(Icons.chat_bubble_outline),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
        Expanded(
          child: Consumer<UserProvider>(
            builder: (_, userProv, child) {
              return Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    postsProvider.savePost(userProv.currentuser!, widget.post);
                  },
                  icon: postsProvider.isSaved(
                          userProv.currentuser!.postsSaved, widget.post.postId)
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_border_rounded),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
