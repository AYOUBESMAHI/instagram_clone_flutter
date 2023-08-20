import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../Utils/Constants.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String id, String img) async {
    if (img.isEmpty) {
      return profileImageNetwork;
    }
    try {
      final ref = _firebaseStorage
          .ref()
          .child("/Insta_User_Image/Profiles")
          .child("$id.png");
      await ref.putFile(File(img));
      return ref.getDownloadURL();
    } catch (err) {
      print("Error Uploading Image ===> $err");
      return profileImageNetwork;
    }
  }

  Future<String> uploadPostMedia(
      String id, String postid, String type, String media) async {
    try {
      if (type == "image") {
        final ref = _firebaseStorage
            .ref()
            .child("/Insta_User_Image/Posts/$id")
            .child("$postid.png");
        await ref.putFile(File(media));
        return ref.getDownloadURL();
      } else {
        final ref = _firebaseStorage
            .ref()
            .child("/Insta_User_Image/Posts/$id")
            .child("$postid.mp4");
        await ref.putFile(File(media));
        return ref.getDownloadURL();
      }
    } catch (err) {
      print("Error Uploading uploadPostImage ===> $err");
      rethrow;
    }
  }

  Future<String> uploadStoryImage(
      String id, String storyId, String media) async {
    try {
      final ref = _firebaseStorage
          .ref()
          .child("/Insta_User_Image/Stories/$id")
          .child("$storyId.png");
      await ref.putFile(File(media));
      return ref.getDownloadURL();
    } catch (err) {
      print("Error Uploading uploadStoryImage ===> $err");
      rethrow;
    }
  }

  Future<String> uploadMessageImage(
      String id, String chatId, String media) async {
    try {
      final ref = _firebaseStorage
          .ref()
          .child("/Insta_User_Image/Chats/$chatId")
          .child("$id.png");
      await ref.putFile(File(media));
      return ref.getDownloadURL();
    } catch (err) {
      print("Error Uploading uploadMessageImage ===> $err");
      rethrow;
    }
  }
}
