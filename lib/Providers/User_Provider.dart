import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/Post.dart';
import '../Models/Story.dart';
import '../Models/User.dart';

import '../Services/firebase_auth_service.dart';
import '../Services/firebase_firestore_service.dart';
import '../Services/firebase_storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    _userCheckController.add(_currentuser == null);
  }
  User? _currentuser;

  User? get currentuser => _currentuser;

  final _userCheckController = StreamController<bool>.broadcast();
  Stream get userCheckController => _userCheckController.stream;

  @override
  void dispose() {
    super.dispose();
    _userCheckController.close();
  }

  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  //Authentification
  Future<void> createUser(
      String email, String password, String username, String image) async {
    try {
      String id = await _authService.createUserFirebase(email, password);
      String updatedImage = await _storageService.uploadProfileImage(id, image);
      _currentuser = User(id, username, updatedImage, email);

      notifyListeners();
      await _firestoreService.setUser(_currentuser!);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signInUser(String email, String password) async {
    try {
      String id = await _authService.signInUserFirebase(email, password);
      User user = await _firestoreService.getUser(id);
      _currentuser = user;
      notifyListeners();
    } catch (err) {
      print("signInUser Error ==> $err ");
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _authService.signOutFirebase();
      _currentuser = null;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  void syncCurrentUser() async {
    final snapshots = _firestoreService.userStream(currentuser!.id);
    snapshots.listen((event) {
      if (event.exists) {
        _currentuser = User.mapToUser(event.data()!);
        notifyListeners();
      }
    });
  }

//Follow an unfollow

  Future<void> followUser(User user) async {
    user.followers.add(currentuser!.id);
    currentuser!.following.add(user.id);
    await _firestoreService.setUser(user);
    await _firestoreService.setUser(currentuser!);
  }

  Future<void> unfollowUser(User user) async {
    user.followers.remove(currentuser!.id);
    currentuser!.following.remove(user.id);
    await _firestoreService.setUser(user);
    await _firestoreService.setUser(currentuser!);
  }

//Post

  Future<void> addPost(Post post) async {
    try {
      List<Map<String, String>> updatedMedias = [];
      for (var p in post.media) {
        String updatedmedia = await _storageService.uploadPostMedia(
            post.author, post.postId, p["type"]!, p["media"]!);
        updatedMedias.add({"type": p["type"]!, "media": updatedmedia});
      }
      post.media = updatedMedias;
      await _firestoreService.setPost(post);
      currentuser!.posts.add(
        {
          "postId": post.postId,
          "date": post.timestamp.toIso8601String(),
        },
      );
      await _firestoreService.setUser(_currentuser!);
    } catch (err) {
      print("addPost Error ===> $err");
      rethrow;
    }
  }

//Story

  Future<void> addStory(Story story) async {
    try {
      String updatedmedia = await _storageService.uploadStoryImage(
          story.authorId, story.storyId, story.media);

      story.media = updatedmedia;
      await _firestoreService.setStory(story);
      currentuser!.stories.add(
        {
          "storyId": story.storyId,
          "date": story.timestamp.toIso8601String(),
        },
      );
      await _firestoreService.setUser(_currentuser!);
    } catch (err) {
      rethrow;
    }
  }

//Chat

  Future<void> addNewchat(String chatId, User user) async {
    await _firestoreService.setNewChat(
      chatId,
      currentuser!.id,
      currentuser!.username,
      currentuser!.profileImageUrl,
      user.id,
      user.username,
      user.profileImageUrl,
    );
    _currentuser!.chatIds.add({
      "userId": user.id,
      "chatId": chatId,
    });
  }

  Future<List<Map<String, dynamic>>> getchats() async {
    List<Map<String, dynamic>> chats = [];
    for (var chat in currentuser!.chatIds) {
      chats.add(await _firestoreService.getUserChat(chat["chatId"]!));
    }
    chats.sort((a, b) => (b["lastMessageTime"] as Timestamp)
        .toDate()
        .compareTo((a["lastMessageTime"] as Timestamp).toDate()));
    return chats;
  }
}
