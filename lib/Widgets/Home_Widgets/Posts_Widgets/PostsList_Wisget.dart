import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Model
import '../../../Models/User.dart';
//Provider
import '../../../Providers/User_Provider.dart';
import '../../../Providers/Posts_Provider.dart';
//Widget
import '../../SinglePost_Widgets/SinglePost.dart';
import 'EmptyPostsWidget.dart';

class PostsList extends StatelessWidget {
  final Function changePage;
  const PostsList(this.changePage, {super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).currentuser!;
    return FutureBuilder(
        future: Provider.of<PostsProvider>(context, listen: false)
            .fetchHomePosts(user),
        builder: (ctx, snapchot) {
          if (snapchot.connectionState == ConnectionState.done) {
            if (Provider.of<PostsProvider>(context, listen: false)
                .homePosts
                .isEmpty) {
              return SliverToBoxAdapter(child: EmptyPostsWidget(changePage));
            }
            return Consumer<PostsProvider>(
                builder: (ctx, postsProvider, child) {
              var homePosts = postsProvider.homePosts;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, i) =>
                        SinglePost(homePosts[i]["user"], homePosts[i]['post']),
                    childCount: homePosts.length),
              );
            });
          } else {
            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
