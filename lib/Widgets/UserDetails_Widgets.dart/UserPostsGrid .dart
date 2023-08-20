import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Provider
import '../../Providers/Posts_Provider.dart';
//Page
import 'PostsPage.dart';
//Models
import '../../Models/User.dart';

enum Type { all, saves, likes }

class UserPostsGrid extends StatelessWidget {
  final User user;
  final Type type;
  const UserPostsGrid(this.user, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    return FutureBuilder(
        future: type == Type.all
            ? postsProvider.fetchUserPosts(user, user.posts)
            : type == Type.likes
                ? postsProvider.fetchUserPosts(user, user.postsLiked)
                : postsProvider.fetchUserPosts(user, user.postsSaved),
        builder: (context, snapchot) {
          if (snapchot.connectionState == ConnectionState.done) {
            var posts = snapchot.data!;
            return SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: .4,
                crossAxisSpacing: .6,
                childAspectRatio: .74,
              ),
              delegate: SliverChildBuilderDelegate((_, i) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => PostsPage(posts, i))),
                    child: Container(
                        color: Colors.grey.shade200,
                        child: Image.network(posts[i].media[0]["media"]!)));
              }, childCount: posts.length),
            );
          }
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
