import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Providerq
import '../../Providers/User_Provider.dart';
//Page
import '../../Widgets/ListChats_Widgets/SingleChat.dart';
import 'Chat_Page.dart';
//Service
import '../../Services/firebase_firestore_service.dart';
//Model
import '../../Models/User.dart';
//Utils
import '../../Utils/Helpers.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  bool isLoading = false;
  bool ischanged = false;
  late UserProvider userProvider;
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> searchedChats = [];
  final _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.clear();
    _textController.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!ischanged) {
      await fetchChatsList();
      ischanged = true;
    }
  }

  Future<void> fetchChatsList() async {
    setState(() {
      isLoading = true;
    });
    chats = await userProvider.getchats();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = userProvider.currentuser!;

//Search Chat User
    if (_textController.text.isNotEmpty) {
      searchedChats = containsUsername(chats, _textController.text);
    } else {
      searchedChats = [];
    }
    List<Map<String, dynamic>> result = [];
    if (searchedChats.isEmpty) {
      result = chats;
    } else {
      result = searchedChats;
    }
    //List Of Chats
    if (!isLoading) {
      if (chats.isNotEmpty) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 226, 226),
                    ),
                    controller: _textController,
                    onChanged: (vak) => setState(() {}),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      var participants = result[i]["participants"];

                      String idReceiver =
                          participants[0]["id"] == currentUser.id
                              ? participants[1]["id"]
                              : participants[0]["id"];
                      String username = participants[0]["id"] == currentUser.id
                          ? participants[1]["username"]
                          : participants[0]["username"];
                      String image = participants[0]["id"] == currentUser.id
                          ? participants[1]["image"]
                          : participants[0]["image"];
                      String lastMessage = result[i]["lastMessage"];
                      Timestamp sendAt = result[i]["lastMessageTime"];
                      return Container(
                        margin: const EdgeInsets.all(4),
                        child: GestureDetector(
                            onTap: () async {
                              User user = await FirebaseFirestoreService()
                                  .getUser(idReceiver);
                              String chatId = containsSameId(
                                  currentUser.chatIds, user.chatIds, "chatId")!;
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) => ChatPage(chatId, user)))
                                  .then((value) async {
                                fetchChatsList();
                              });
                            },
                            child: SingleChat(
                                username, image, lastMessage, sendAt)),
                      );
                    },
                    itemCount: result.length,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      //Chat Is Empty
      return emptyChat();
    }
    //Still Loading
    return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())));
  }

  Widget emptyChat() {
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: const EdgeInsets.all(32),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Message friends with Direct",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Send private messages or share your favorit posts directly with friends ",
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
