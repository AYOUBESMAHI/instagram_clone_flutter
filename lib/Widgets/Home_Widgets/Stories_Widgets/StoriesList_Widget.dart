import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';

import 'package:provider/provider.dart';

//Widget
import 'SingleStory.dart';
//Model
import '../../../Models/User.dart';
//Provider
import '../../../Providers/User_Provider.dart';
import '../../../Providers/Stories_Provider.dart';

class StoriesList extends StatelessWidget {
  final Function changeFunc;
  const StoriesList(this.changeFunc, {super.key});

  Widget builEmptyStory(BuildContext context, User user) {
    return InkWell(
      onTap: () => changeFunc(0),
      child: Container(
        height: 95,
        margin: const EdgeInsets.symmetric(horizontal: 7),
        alignment: Alignment.centerLeft,
        child: Stack(children: [
          CircleAvatar(
              radius: 36,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(user.profileImageUrl)),
          const Positioned(
              right: 1,
              bottom: 5,
              child: Icon(
                Icons.add_circle_rounded,
                size: 23,
                color: Colors.blue,
              ))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).currentuser!;
    return FutureBuilder(
        future: Provider.of<StoriesProvider>(context, listen: false)
            .fetchUsersStories(user),
        builder: (ctx, snapchot) {
          if (snapchot.connectionState == ConnectionState.done) {
            return Consumer<StoriesProvider>(
                builder: (ctx, storiesProvider, child) {
              var availableStories = storiesProvider.availableStories;

              return SizedBox(
                height: 95,
                width: double.infinity,
                child: StoryListView(
                    pageTransform: const StoryPage3DTransform(),
                    buttonSpacing: 5,
                    buttonWidth: 75,
                    buttonDatas: [
                      ...availableStories.map((stories) {
                        if (stories.isEmpty) {
                          return StoryButtonData(
                            storyPages: [],
                            child: builEmptyStory(context, user),
                            borderDecoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            buttonDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(user.profileImageUrl),
                                    fit: BoxFit.cover)),
                            segmentDuration: const Duration(seconds: 3),
                          );
                        }
                        final singleStory = SingleStory(stories);
                        return singleStory.getStoryButtonData(context);
                      })
                    ]),
              );
            });
          }
          return builEmptyStory(context, user);
        });
  }
}
