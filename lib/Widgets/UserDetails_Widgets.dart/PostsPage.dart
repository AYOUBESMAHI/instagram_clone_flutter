import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Model
import '../../Models/Post.dart';
//Provider
import '../../Providers/Users_Provider.dart';
//Widget
import '../SinglePost_Widgets/SinglePost.dart';

class PostsPage extends StatelessWidget {
  final List<Post> posts;
  final int initialPage;
  const PostsPage(this.posts, this.initialPage, {super.key});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: initialPage);
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (_, i) => FutureBuilder(
            future: Provider.of<UsersProvider>(context)
                .fetchUserId(posts[i].author),
            builder: (ctx, snapchot) {
              if (snapchot.connectionState == ConnectionState.done) {
                return SinglePost(snapchot.data!, posts[i]);
              } else {
                return Container(
                    height: 760,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator());
              }
            }),
        itemCount: posts.length,
        controller: pageController,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
