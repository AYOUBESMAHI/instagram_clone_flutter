import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intagram/Services/firebase_storage_service.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
//Models
import '../../Models/User.dart';
//Provider
import '../../Providers/User_Provider.dart';
//Service
import '../../Services/firebase_firestore_service.dart';
//Widget
import '../../Utils/Helpers.dart';
import '../../Widgets/Chat_Widget/MessageBubble.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final User receiver;
  const ChatPage(this.chatId, this.receiver, {super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final _inputcontroller = TextEditingController();
  late User currntUser;
  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImage(ImageSource source) async {
    var img = await ImagePicker().pickImage(
      source: source,
    );
    if (img != null) {
      mediafile = img.path;
    }
  }

  String? mediaLink;
  String? mediafile;

  @override
  Widget build(BuildContext context) {
    currntUser = Provider.of<UserProvider>(context, listen: false).currentuser!;

    return Scaffold(
      body: StreamBuilder(
        stream: _firestoreService.getmessages(widget.chatId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                reverse: true,
                itemBuilder: (_, i) => MessageBubble(
                    data[i]["SenderUsername"],
                    data[i]["Content"],
                    data[i]["SenderId"] == currntUser.id,
                    data[i]["CreatedAt"],
                    data[i]["SenderprofileImage"],
                    data[i]["isMedia"]),
                itemCount: data.length,
              )),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              await chooseSourse(context, pickImage);
                              if (mediafile != null) {
                                mediaLink = await FirebaseStorageService()
                                    .uploadMessageImage(const Uuid().v4(),
                                        widget.chatId, mediafile!);

                                _firestoreService.addNewMessage(
                                    widget.chatId,
                                    mediaLink!,
                                    currntUser.id,
                                    currntUser.username,
                                    currntUser.profileImageUrl,
                                    true);
                                mediaLink = null;
                              }
                            },
                            child: const Icon(
                              Icons.image,
                              size: 32,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(29)),
                          )),
                      controller: _inputcontroller,
                    )),
                    IconButton(
                        onPressed: () {
                          if (_inputcontroller.text.trim().isNotEmpty) {
                            String message = _inputcontroller.text.trim();
                            _inputcontroller.clear();
                            _firestoreService.addNewMessage(
                                widget.chatId,
                                message,
                                currntUser.id,
                                currntUser.username,
                                currntUser.profileImageUrl,
                                false);
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color.fromARGB(255, 226, 60, 255),
                        )),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
