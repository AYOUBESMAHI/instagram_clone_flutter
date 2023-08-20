import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Models/Story.dart';
import '../Models/User.dart';
import '../Services/firebase_firestore_service.dart';

class StoriesProvider extends ChangeNotifier {
  List<List<Story>> availableStories = [];
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();

  Future<void> fetchUsersStories(User user) async {
    availableStories = [];
    // await cleanStories(user);
    if (user.stories.isNotEmpty) {
      List<Story> userStories = await fetchSingleUserStories(user);
      availableStories.add(userStories);
    } else {
      availableStories.add([]);
    }

    for (var id in user.following) {
      var followeduser = await checkSroriesExist(id);
      if (followeduser != null) {
        List<Story> userStories = await fetchSingleUserStories(followeduser);
        availableStories.add(userStories);
      }
    }
    print('ss======> ${availableStories.length}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<User?> checkSroriesExist(String id) async {
    User user = await _firestoreService.getUser(id);
    var stories = [];
    for (var story in user.stories) {
      // if (isDateBefore24Hours(story["date"])) {
      stories.add(story);
      // }
    }
    if (stories.isEmpty) {
      return null;
    } else {
      return user;
    }
  }

  Future<List<Story>> fetchSingleUserStories(User user) async {
    List<Story> userStories = [];
    for (var storyData in user.stories) {
      Story story =
          await _firestoreService.getStory(user.id, storyData["storyId"]!);
      userStories.add(story);
    }
    return userStories;
  }

  Future<void> cleanStories(User user) async {
    var deletedStories = [];
    for (var story in user.stories) {
      // if (!isDateBefore24Hours(story["date"])) {
      deletedStories.add(story);
      // }
    }
    for (var story in deletedStories) {
      user.stories.remove(story);
      await _firestoreService.deleteStory(user.id, story);
    }
    await _firestoreService.setUser(user);
  }
}
