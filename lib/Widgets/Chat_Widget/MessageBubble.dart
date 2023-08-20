import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Utils
import '../../Utils/Helpers.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final Timestamp timestamp;
  final String username;
  final bool isCurrentUser;
  final String profileImage;
  final bool isMedia;
  const MessageBubble(this.username, this.message, this.isCurrentUser,
      this.timestamp, this.profileImage, this.isMedia,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: isCurrentUser
            ? buildCurrentUserMessage()
            : buildOtherUserMessage());
  }

  Widget buildOtherUserMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(width: 4),
            Container(
              width: 150,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.centerLeft,
              child: isMedia
                  ? Image.network(
                      message,
                      fit: BoxFit.cover,
                    )
                  : Text(
                      message,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: true,
                    ),
            ),
          ],
        ),
        Container(
            width: 150,
            margin: const EdgeInsets.only(left: 4, top: 5),
            alignment: Alignment.center,
            child: Text(formatTimeDifference(timestamp.toDate())))
      ],
    );
  }

  Widget buildCurrentUserMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 150,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerLeft,
          child: isMedia
              ? Image.network(
                  message,
                  fit: BoxFit.cover,
                )
              : Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
        ),
        Container(
            width: 150,
            margin: const EdgeInsets.only(left: 4, top: 5),
            alignment: Alignment.center,
            child: Text(formatTimeDifference(timestamp.toDate())))
      ],
    );
  }
}
