import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
//Models
import '../../Models/User.dart';
//Provider
import '../../Providers/User_Provider.dart';
//Screen
import '../../Screens/Pages/Chat_Page.dart';
//Widget
import '../../Services/firebase_firestore_service.dart';
import 'UsersList.dart';
//Utils
import '../../Utils/Helpers.dart';

// ignore: must_be_immutable
class UserProfileInfo extends StatelessWidget {
  User user;

  UserProfileInfo(this.user, {super.key});

  Widget buildProfileNumbers(String title, String sub) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        sub,
        style: const TextStyle(),
        softWrap: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentUser =
        Provider.of<UserProvider>(context, listen: false).currentuser!;
    return StreamBuilder(
      stream: FirebaseFirestoreService().userStream(user.id),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          user = User.mapToUser(snapshot.data!.data());
        }
        return Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 80,
                              child: buildProfileNumbers(
                                  user.posts.length.toString(), "Posts"),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            UsersList(user.followers))),
                                child: buildProfileNumbers(
                                    user.followers.length.toString(),
                                    "Followers"),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            UsersList(user.following))),
                                child: buildProfileNumbers(
                                    user.following.length.toString(),
                                    "Following"),
                              ),
                            ),
                          ],
                        ),
                        if (currentUser != user)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Consumer<UserProvider>(
                                builder: (ctx, userProvider, child) =>
                                    ElevatedButton(
                                        onPressed: () {
                                          currentUser =
                                              userProvider.currentuser!;
                                          if (!currentUser.following
                                              .contains(user.id)) {
                                            userProvider.followUser(user);
                                          } else {
                                            userProvider.unfollowUser(user);
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: currentUser
                                                    .following
                                                    .contains(user.id)
                                                ? MaterialStateProperty.all(
                                                    Colors.grey)
                                                : MaterialStateProperty.all(
                                                    Colors.blue)),
                                        child: Text(
                                          currentUser.following
                                                  .contains(user.id)
                                              ? "Unfollow"
                                              : "Follow",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                              ),
                              Consumer<UserProvider>(
                                builder: (ctx, userProvider, child) =>
                                    ElevatedButton(
                                        onPressed: () {
                                          var chatId = containsSameId(
                                              currentUser.chatIds,
                                              user.chatIds,
                                              "chatId");
                                          if (chatId == null) {
                                            chatId = const Uuid().v4();
                                            user.chatIds.add({
                                              "userId": currentUser.id,
                                              "chatId": chatId,
                                            });
                                            userProvider.addNewchat(
                                                chatId, user);
                                          }
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ChatPage(chatId!, user)));
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey.shade200)),
                                        child: const Text(
                                          "Message",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                              ),
                            ],
                          )
                      ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
