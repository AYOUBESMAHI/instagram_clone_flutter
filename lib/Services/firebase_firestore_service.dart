import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Post.dart';
import '../Models/Story.dart';
import '../Models/User.dart';
import '../Utils/Constants.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
//Users
  Future<void> setUser(User user) async {
    try {
      final doc = firestore.collection(usersPath).doc(user.id);
      doc.set(user.usertoMap());
    } on FirebaseException catch (err) {
      print("setUser err ==> $err");
      throw err.message!;
    }
  }

  Future<User> getUser(String id) async {
    try {
      final doc = firestore.collection(usersPath).doc(id);
      var snapchot = await doc.get();
      return User.mapToUser(snapchot.data()!);
    } on FirebaseException catch (err) {
      print("getUser err ==> $err");
      throw err.message!;
    }
  }

  Stream userStream(String id) {
    try {
      final snapchot = firestore.collection(usersPath).doc(id).snapshots();
      return snapchot;
    } on FirebaseException catch (err) {
      print("getUserSnaphot err ==> $err");
      throw err.message!;
    }
  }

  Future<List<User>> getSeachedUsers(String query) async {
    try {
      final coll = firestore.collection(usersPath);
      List<User> users = [];
      var snapchot = await coll
          .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
          .get();
      if (snapchot.docs.isNotEmpty) {
        for (var d in snapchot.docs) {
          users.add(User.mapToUser(d.data()));
        }
      }
      return users;
    } on FirebaseException catch (err) {
      print("getSeachedUsers err ==> $err");
      throw err.message!;
    }
  }

  Future<List<User>> getFollowedUsers(User user) async {
    try {
      List<User> users = [];
      if (user.following.isNotEmpty) {
        for (var followed in user.following) {
          var userF = await getUser(followed);
          users.add(userF);
        }
      }
      return users;
    } on FirebaseException catch (err) {
      print("getSeachedUsers err ==> $err");
      throw err.message!;
    }
  }

//Chats

  Future<String> setNewChat(String chatId, String userID1, String username1,
      String image1, String userID2, String username2, String image2) async {
    try {
      final doc = firestore.collection(chatPath).doc(chatId);
      await doc.set({
        "participants": [
          {'id': userID1, 'username': username1, 'image': image1},
          {'id': userID2, 'username': username2, 'image': image2},
        ],
        "lastMessage": "",
        "lastMessageTime": FieldValue.serverTimestamp(),
      });
      await firestore.collection(usersPath).doc(userID1).update({
        "chatIds": FieldValue.arrayUnion([
          {"userId": userID2, "chatId": chatId}
        ])
      });
      await firestore.collection(usersPath).doc(userID2).update({
        "chatIds": FieldValue.arrayUnion([
          {"userId": userID1, "chatId": chatId}
        ])
      });
      return chatId;
    } catch (error) {
      print("setNewChat Error===> $error");

      rethrow;
    }
  }

  Future<void> addNewMessage(String chatId, String message, String userID1,
      String username, String profileImage, bool isMedia) async {
    try {
      final doc = firestore.collection(chatPath).doc(chatId);
      final subCollectionRef = doc.collection("messages");
      await subCollectionRef.add({
        'Content': message,
        'SenderId': userID1,
        'SenderUsername': username,
        'SenderprofileImage': profileImage,
        'isMedia': isMedia,
        'CreatedAt': Timestamp.now(),
      });

      await doc.update({
        "lastMessage": isMedia ? "" : message,
        "lastMessageTime": Timestamp.now(),
      });
    } catch (error) {
      print("setNewChat Error===> $error");
      //ToDo Rethrow
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getmessages(String chatId) {
    return firestore
        .collection(chatPath)
        .doc(chatId)
        .collection("messages")
        .orderBy('CreatedAt', descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>> getUserChat(String id) async {
    try {
      final doc = firestore.collection(chatPath).doc(id);
      var snapchot = await doc.get();

      return snapchot.data()!;
    } on FirebaseException catch (err) {
      print("getUserChats err ==> $err");
      throw err.message!;
    }
  }

  //Posts

  Future<void> setPost(Post post) async {
    try {
      final doc = firestore
          .collection("$postsPath${post.author}/userPosts")
          .doc(post.postId);
      await doc.set(post.posttoMap());
    } on FirebaseException catch (err) {
      print("setPost err ==> $err");
      throw err.message!;
    }
  }

  Future<Post?> getPost(String id, String postId) async {
    try {
      final doc = firestore.collection("$postsPath$id/userPosts").doc(postId);
      var snapshot = await doc.get();
      if (snapshot.data() == null) {
        print("Document Path: ${doc.path}");
        print("Snapshot Data: ${snapshot.data()}");
        return null;
      }
      return Post.mapToPost(snapshot.data()!);
    } catch (error) {
      print("getPost Error ==> $error");
      rethrow;
    }
  }

  Stream getPostStream(String id, String postId) {
    try {
      final doc = firestore.collection("$postsPath$id/userPosts").doc(postId);
      var stream = doc.snapshots();
      return stream;
    } catch (error) {
      print("getPostStream Error ==> $error");
      rethrow;
    }
  }

//Stories

  Future<void> setStory(Story story) async {
    try {
      final doc = firestore
          .collection("$postsPath${story.authorId}/userStories")
          .doc(story.storyId);
      await doc.set(story.storytoMap());
    } on FirebaseException catch (err) {
      print("setStory err ==> $err");
      throw err.message!;
    }
  }

  Future<void> deleteStory(String uid, String storyId) async {
    try {
      final doc =
          firestore.collection("$postsPath${uid}/userStories").doc(storyId);
      await doc.delete();
    } on FirebaseException catch (err) {
      print("deleteStory err ==> $err");
      throw err.message!;
    }
  }

  Future<Story> getStory(String id, String storyId) async {
    try {
      final doc =
          firestore.collection("$postsPath$id/userStories").doc(storyId);
      var snapchot = await doc.get();
      return Story.mapToStory(snapchot.data()!);
    } catch (error) {
      print("getStory Error ==> $error");
      rethrow;
    }
  }
}
