import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils/Helpers.dart';

class SingleChat extends StatelessWidget {
  final String username;
  final String image;
  final String lastMessage;
  final Timestamp sendAt;
  const SingleChat(this.username, this.image, this.lastMessage, this.sendAt,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(image),
      ),
      title: Text(
        username,
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: Row(children: [
        Expanded(
          child: Text(
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            lastMessage,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Text(formatTimeDifference(sendAt.toDate())),
      ]),
    );
  }
}
