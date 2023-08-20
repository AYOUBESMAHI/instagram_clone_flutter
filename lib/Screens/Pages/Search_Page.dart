import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Screen
import 'User_Details_Page.dart';
//Provider
import '../../Providers/Users_Provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  late UsersProvider usersProvider;
  @override
  void initState() {
    super.initState();
    usersProvider = Provider.of<UsersProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    usersProvider.clearSearch();
  }

  void searchUsers() async {
    await usersProvider.fetchUsers(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textInputAction: TextInputAction.search,
            controller: _searchController,
            onSubmitted: (val) => searchUsers(),
          ),
        ),
        body: SizedBox(
          height: 400,
          child: Consumer<UsersProvider>(builder: (ctx, users, child) {
            return ListView.builder(
              itemBuilder: (ctx, i) => InkWell(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (_) =>
                            UserDetailsPage(users.searchedUsers[i])))
                    .then((value) => usersProvider.clearSearch()),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(users.searchedUsers[i].profileImageUrl)),
                  title: Text(users.searchedUsers[i].username),
                ),
              ),
              itemCount: users.searchedUsers.length,
            );
          }),
        ));
  }
}
