import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Model
import '../../Models/User.dart';
//Provider
import '../../Providers/User_Provider.dart';
//Widget
import '../../Widgets/UserDetails_Widgets.dart/UserProfileInfo.dart';
import '../../Widgets/UserDetails_Widgets.dart/UserPostsGrid%20.dart';

class UserDetailsPage extends StatefulWidget {
  final User user;
  const UserDetailsPage(this.user, {super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with TickerProviderStateMixin {
  late TabController usertabController;
  late TabController otherstabController;

  @override
  void initState() {
    super.initState();
    usertabController = TabController(length: 3, vsync: this);
    otherstabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    usertabController.dispose();
    otherstabController.dispose();
    super.dispose();
  }

  List<Widget> userTabs() {
    return [
      const Tab(
        icon: Icon(
          Icons.grid_on,
          color: Colors.black,
          size: 30,
        ),
      ),
      const Tab(
        icon: Icon(
          Icons.favorite,
          color: Color.fromARGB(255, 255, 0, 0),
          size: 30,
        ),
      ),
      const Tab(
        icon: Icon(
          Icons.bookmark,
          color: Color.fromARGB(255, 91, 89, 89),
          size: 30,
        ),
      ),
    ];
  }

  Widget userTabView() {
    return TabBarView(
      controller: usertabController,
      children: [
        CustomScrollView(
          slivers: [UserPostsGrid(widget.user, Type.all)],
        ),
        CustomScrollView(
          slivers: [UserPostsGrid(widget.user, Type.likes)],
        ),
        CustomScrollView(
          slivers: [UserPostsGrid(widget.user, Type.saves)],
        ),
      ],
    );
  }

  List<Widget> othersTabs() {
    return [
      const Tab(
        icon: Icon(
          Icons.grid_on,
          color: Colors.black,
          size: 30,
        ),
      ),
    ];
  }

  Widget otherTabView() {
    return TabBarView(
      controller: otherstabController,
      children: [
        CustomScrollView(
          slivers: [UserPostsGrid(widget.user, Type.all)],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentuser!;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.username),
          actions: [
            if (currentUser == widget.user)
              Consumer<UserProvider>(
                builder: ((context, value, child) => IconButton(
                    onPressed: () async {
                      value.logout();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Color.fromARGB(255, 255, 17, 0),
                    ))),
              )
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: UserProfileInfo(widget.user)),
              SliverToBoxAdapter(
                child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                    child: Text(
                      widget.user.username,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "LisuBosa"),
                    )),
              ),
              const SliverToBoxAdapter(
                child: Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
              ),
              SliverAppBar(
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TabBar(
                  indicatorColor: Colors.pink,
                  controller: currentUser == widget.user
                      ? usertabController
                      : otherstabController,
                  tabs: currentUser == widget.user ? userTabs() : othersTabs(),
                ),
              ),
            ];
          },
          body: currentUser == widget.user ? userTabView() : otherTabView(),
        ));
  }
}
