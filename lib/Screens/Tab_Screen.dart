import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Pages
import 'Pages/Post_Page.dart';
import 'Pages/Home_Page.dart';
import 'Pages/Search_Page.dart';
import 'Pages/Story_Page.dart';
import 'Pages/User_Details_Page.dart';
//Provirs
import '../Providers/User_Provider.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final _pageController = PageController(initialPage: 1);
  int pageIndex = 1;
  int navIndex = 0;
  void changePage(int page) {
    setState(() {
      _pageController.jumpToPage(page);
      pageIndex = page;
      if (pageIndex != 0) {
        navIndex = pageIndex - 1;
      }
    });
  }

  void changeNav(int nav) {
    setState(() {
      navIndex = nav;
      pageIndex = navIndex + 1;
      _pageController.jumpToPage(pageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    userprovider.syncCurrentUser();
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (val) => changePage(val),
          children: [
            StoryPage(changePage),
            HomePage(changePage),
            const SearchPage(),
            AddPostPage(changePage),
            UserDetailsPage(userprovider.currentuser!)
          ],
        ),
      ),
      bottomNavigationBar: pageIndex != 0
          ? BottomNavigationBar(
              selectedItemColor: Colors.black87,
              unselectedItemColor: const Color.fromARGB(255, 43, 39, 39),
              elevation: 12,
              currentIndex: navIndex,
              onTap: (value) => changeNav(value),
              items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled),
                      label: "",
                      backgroundColor: Colors.white70),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: "",
                      backgroundColor: Colors.white70),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_box_rounded),
                      label: "",
                      backgroundColor: Colors.white70),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "",
                      backgroundColor: Colors.white70),
                ])
          : null,
    );
  }
}
