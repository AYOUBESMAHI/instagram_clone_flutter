import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
//Models
import '../../Models/Post.dart';
import '../../Models/User.dart';
//Providers
import '../../Providers/Posts_Provider.dart';
import '../../Providers/User_Provider.dart';

import '../../Services/firebase_firestore_service.dart';
import 'LikeCommentSection.dart';
import 'PostMediaSection.dart';
import 'UserDetailsHeader.dart';

// ignore: must_be_immutable
class SinglePost extends StatelessWidget {
  final User user;
  Post post;
  SinglePost(this.user, this.post, {super.key});

  bool isHeartAnimating = false;
  void updateAnimation() {
    isHeartAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    PostsProvider postsProvider = Provider.of<PostsProvider>(context);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    User currentUser = userProvider.currentuser!;

    return StreamBuilder(
        stream:
            FirebaseFirestoreService().getPostStream(post.author, post.postId),
        builder: (ctx, snapchot) {
          if (snapchot.hasData) {
            post = Post.mapToPost(snapchot.data!.data());
          }
          return SizedBox(
            height: 760,
            width: 300,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserDetailsHeader(user),
                  const SizedBox(height: 7),
                  Expanded(child: PostMediaSection(post, user)),
                  const SizedBox(height: 7),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text("${post.likes.length} Likes")),
                  LikeCommentSaveSection(post, currentUser, commentsbar),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        Text(post.caption),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        commentsbar(context, postsProvider, currentUser),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: Text(
                          "View All ${post.comments.length} Comments",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  GestureDetector(
                    onTap: () =>
                        commentsbar(context, postsProvider, currentUser),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(currentUser.profileImageUrl),
                          ),
                          const SizedBox(width: 6),
                          const Text("Add a comment "),
                        ],
                      ),
                    ),
                  ),
                ]),
          );
        });
  }

  void commentsbar(
      BuildContext context, PostsProvider postsProvider, User currentUser) {
    final commentInput = TextEditingController();
    showModalBottomSheet(
        context: context,
        elevation: 8,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(17))),
        builder: (_) {
          var comments = post.comments;
          return Container(
            height: 500,
            margin: const EdgeInsets.all(6),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(_).viewInsets.bottom),
            child: Column(children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, i) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          NetworkImage(comments[i]['profileImage']!),
                    ),
                    title: Text(comments[i]["username"]!),
                    subtitle: Text(comments[i]["comment"]!),
                  ),
                  itemCount: comments.length,
                ),
              ),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      decoration:
                          const InputDecoration(hintText: "Add comment..."),
                      controller: commentInput,
                    )),
                    IconButton(
                        onPressed: () {
                          if (commentInput.text.isNotEmpty) {
                            postsProvider
                                .commentPost(
                                    post, currentUser, commentInput.text)
                                .then((value) => Navigator.of(_).pop());
                          }
                        },
                        icon: const Icon(Icons.send)),
                  ],
                ),
              )
            ]),
          );
        });
  }
}
