import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Models/Post.dart';
import '../Services/firebase_firestore_service.dart';

class PostsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> homePosts = [];
  List<Post> searchPosts = [];
  List<Post> reelsPosts = [];

  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();

  Future<void> fetchHomePosts(User currentUser) async {
    //Current user Posts
    var Posts = [];

    if (currentUser.posts.isNotEmpty) {
      for (var p in currentUser.posts) {
        Posts.add({
          "userId": currentUser.id,
          "postId": p["postId"],
        });
      }
    }

    //Followers user Posts
    if (currentUser.following.isNotEmpty) {
      for (var flollowing in currentUser.following) {
        var user = await _firestoreService.getUser(flollowing);
        if (user.posts.isNotEmpty) {
          for (var p in user.posts) {
            Posts.add({
              "userId": user.id,
              "postId": p["postId"],
            });
          }
        }
      }
    }

    homePosts = [];
    for (var up in Posts) {
      Post? post = await _firestoreService.getPost(up["userId"], up["postId"]);
      User user = await _firestoreService.getUser(up["userId"]);
      homePosts.add({"user": user, "post": post});
    }
    homePosts.sort(((a, b) => (b["post"] as Post)
        .timestamp
        .compareTo((a["post"] as Post).timestamp)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

//Like Post

  bool isLiked(Post post, String userid) {
    return post.likes.contains(userid);
  }

  Future<void> likePost(Post post, User user) async {
    try {
      if (post.likes.contains(user.id)) {
        post.likes.remove(user.id);
        user.postsLiked.removeWhere((e) => e["postId"] == post.postId);
      } else {
        post.likes.add(user.id);

        print("=====>${user.id}");
        user.postsLiked.add({
          "userId": post.author,
          "postId": post.postId,
        });
      }
      //notifyListeners();
      await _firestoreService.setPost(post);
      await _firestoreService.setUser(user);
    } catch (err) {
      print('likePost Error ==> $err');
    }
  }

//Commnt Post
  bool isCommented(Post post, String userid) {
    for (var comment in post.comments) {
      if (comment["id"] == userid) {
        return true;
      }
    }
    return false;
  }

  Future<void> commentPost(Post post, User user, String comment) async {
    try {
      post.comments.add({
        "id": user.id,
        "comment": comment,
        "username": user.username,
        "profileImage": user.profileImageUrl
      });
      await _firestoreService.setPost(post);

      // notifyListeners();
    } catch (err) {
      print('likePost Error ==> $err');
    }
  }

  bool isSaved(List<Map<String, dynamic>> saves, String postid) {
    for (var save in saves) {
      if (save["postId"] == postid) {
        return true;
      }
    }
    return false;
  }

  Future<void> savePost(User user, Post post) async {
    try {
      if (isSaved(user.postsSaved, post.postId)) {
        user.postsSaved.removeWhere((e) => e["postId"] == post.postId);
      } else {
        user.postsSaved.add({
          "userId": post.author,
          "postId": post.postId,
        });
      }
      //notifyListeners();
      await _firestoreService.setUser(user);
    } catch (err) {
      print("Save post Error ===> $err");
      rethrow;
    }
  }

  Future<List<Post>> fetchUserPosts(
      User user, List<Map<String, String>> postsMap) async {
    try {
      List<Post> posts = [];
      for (var p in postsMap) {
        String id = p.containsKey("userId") ? p["userId"].toString() : user.id;
        Post? post =
            await _firestoreService.getPost(id, p["postId"].toString());
        if (post != null) {
          posts.add(post);
        }
      }
      return posts;
    } catch (err) {
      print("fetchUserPosts Error ===> $err");
      rethrow;
    }
  }
}
