import 'package:flutter/material.dart';

import '../../Models/User.dart';
import '../../Screens/Pages/User_Details_Page.dart';

class UserDetailsHeader extends StatelessWidget {
  final User user;
  const UserDetailsHeader(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => UserDetailsPage(user))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textBaseline: TextBaseline.alphabetic,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
            const SizedBox(width: 6),
            Text(
              user.username,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
