import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Model
import '../../Models/User.dart';
//Providers
import '../../Providers/User_Provider.dart';
import '../../Providers/Users_Provider.dart';
//Pages
import '../../Screens/Pages/User_Details_Page.dart';

class UsersList extends StatelessWidget {
  final List<String> usersId;
  const UsersList(this.usersId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Provider.of<UsersProvider>(context).fetchUsersIds(usersId),
            builder: (ctx, snapchot) {
              if (snapchot.connectionState == ConnectionState.done) {
                var users = snapchot.data!;
                return ListView.builder(
                  itemBuilder: (ctx, i) => Consumer<UserProvider>(
                      builder: (context, userProvider, child) =>
                          buildSingleUser(userProvider, users[i], context)),
                  itemCount: users.length,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Widget buildSingleUser(
      UserProvider userProvider, User user, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => UserDetailsPage(user))),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(user.profileImageUrl),
        ),
        title: Text(user.username),
        trailing: userProvider.currentuser != user
            ? ElevatedButton(
                onPressed: () {
                  if (!userProvider.currentuser!.following.contains(user.id)) {
                    userProvider.followUser(user);
                  } else {
                    userProvider.unfollowUser(user);
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        userProvider.currentuser!.following.contains(user.id)
                            ? MaterialStateProperty.all(Colors.grey)
                            : MaterialStateProperty.all(Colors.blue)),
                child: Text(
                  userProvider.currentuser!.following.contains(user.id)
                      ? "Unfollow"
                      : "Follow",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ))
            : null,
      ),
    );
  }
}
