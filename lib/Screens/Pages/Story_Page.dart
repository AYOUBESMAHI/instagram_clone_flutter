import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
//Models
import '../../../Models/Story.dart';
import '../../../Models/User.dart';
//Provider
import '../../../Providers/User_Provider.dart';
//Helper
import '../../Utils/Helpers.dart';

class StoryPage extends StatefulWidget {
  final Function PageFunc;
  const StoryPage(this.PageFunc, {super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late UserProvider userProvider;
  late User user;
  String? media;
  bool isPicked = false;
  bool ischanged = false;
  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.currentuser!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chooseSourse(context, pickImage).then((value) => widget.PageFunc(1));
    });
  }

  Future<void> pickImage(ImageSource source) async {
    var img = await ImagePicker().pickImage(
      source: source,
    );
    if (img != null) {
      media = img.path;
      await showMedia();
    }
  }

  Future<void> showMedia() async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: SizedBox(
                height: 500,
                width: 500,
                child: Image.file(
                  File(media!),
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      widget.PageFunc(1);
                      Navigator.of(_).pop();
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      Story story = Story(
                          const Uuid().v4(),
                          user.id,
                          user.username,
                          user.profileImageUrl,
                          media!,
                          DateTime.now());
                      userProvider.addStory(story).then((value) {
                        widget.PageFunc(1);
                        Navigator.of(_).pop();
                      });
                    },
                    child: const Text("Save")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (media != null) {}

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
