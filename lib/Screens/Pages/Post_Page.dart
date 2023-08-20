import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
//Widget
import '../../Widgets/Posts_Widgets/MediaInput_Widget.dart';
//Model
import '../../Models/Post.dart';
//Provider
import '../../Providers/User_Provider.dart';

class AddPostPage extends StatefulWidget {
  final Function changePage;
  const AddPostPage(this.changePage, {super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  late UserProvider userProvider;

  final _textController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void resset() {
    _textController.clear();
    medias.clear();
  }

  List<Map<String, String>> medias = [];
  void setMedias(var media) {
    medias.add(media);
  }

  Future<void> addPost() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    await userProvider.addPost(Post(
      const Uuid().v4(),
      userProvider.currentuser!.id,
      medias,
      _textController.text,
      [],
      [],
      DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MediaInput(setMedias),
            Container(
              width: 350,
              color: const Color.fromARGB(255, 231, 226, 219),
              child: TextField(
                controller: _textController,
                onChanged: (value) => setState(() {}),
              ),
            ),
            Container(
              width: 90,
              height: 60,
              margin: const EdgeInsets.only(top: 9),
              padding: const EdgeInsets.all(3),
              child: ElevatedButton(
                  onPressed: ((_textController.text.isEmpty || medias.isEmpty))
                      ? null
                      : () {
                          addPost().then((value) {
                            resset();

                            widget.changePage(1);
                          });
                        },
                  child: !isLoading
                      ? const Text(
                          "Save",
                          style: TextStyle(fontSize: 18),
                        )
                      : const CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
