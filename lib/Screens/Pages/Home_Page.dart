import 'package:flutter/material.dart';

//Page
import 'ListChats_Page.dart';
//Widgets
import '../../Widgets/Home_Widgets/Posts_Widgets/PostsList_Wisget.dart';
import '../../Widgets/Home_Widgets/Stories_Widgets/StoriesList_Widget.dart';

class HomePage extends StatefulWidget {
  final Function changePage;
  const HomePage(this.changePage, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
          body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            title: const Text(
              "Instagram",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: "Courgette"),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ListChatPage()));
                  },
                  icon: const Icon(Icons.send))
            ],
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(child: StoriesList(widget.changePage)),
          const SliverToBoxAdapter(child: SizedBox(height: 5)),
          PostsList(widget.changePage),
        ]),
      )),
    );
  }
}
