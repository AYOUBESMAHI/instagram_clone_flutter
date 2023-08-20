import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//Utils
import '../../Utils/Helpers.dart';
//Widget
import '../SinglePost_Widgets/VideoPlayer_Widget.dart';

class MediaInput extends StatefulWidget {
  final Function setMedias;
  const MediaInput(this.setMedias, {super.key});

  @override
  State<MediaInput> createState() => _MediaInputState();
}

class _MediaInputState extends State<MediaInput> {
  List<Map<String, String>> _medias = [];

  Future<void> pickImage(ImageSource source) async {
    var img = await ImagePicker().pickImage(
      source: source,
    );
    if (img != null) {
      setState(() {
        var media = {"type": "image", "media": img.path};
        _medias.add(media);
        widget.setMedias(media);
      });
    }
  }

  Future<void> pickVideo(ImageSource source) async {
    var vid = await ImagePicker()
        .pickVideo(source: source, maxDuration: const Duration(seconds: 30));
    if (vid != null) {
      setState(() {
        var media = {"type": "video", "media": vid.path};
        _medias.add(media);
        widget.setMedias(media);
      });
    }
  }

  void deleteMedia(int index) {
    _medias.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 500,
        width: 450,
        alignment: Alignment.center,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, i) {
            if (i == _medias.length) {
              return InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          buildAlertDialog(_, pickVideo, pickImage));
                },
                child: Container(
                  width: 380,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(122, 203, 196, 203),
                      border: Border.all(
                          width: 3, color: Color.fromARGB(255, 0, 0, 0))),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.upload,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              );
            } else {
              if (_medias[i]["type"] == "image") {
                return Container(
                  width: 380,
                  height: 400,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Image.file(
                        File(_medias[i]["media"]!),
                        fit: BoxFit.cover,
                      ),
                      buildDeleteIconButton(i),
                    ],
                  ),
                );
              } else {
                return Container(
                    width: 380,
                    height: 400,
                    margin: const EdgeInsets.all(8),
                    child: Stack(children: [
                      VideoPlayerWidget(_medias[i]["media"]!, true),
                      buildDeleteIconButton(i),
                    ]));
              }
            }
          },
          itemCount: 1,
        ),
      ),
    );
  }

  Widget buildDeleteIconButton(int index) {
    return Positioned(
      right: 10,
      child: IconButton(
        onPressed: () {
          deleteMedia(index);
        },
        icon: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.red,
        ),
      ),
    );
  }
}
