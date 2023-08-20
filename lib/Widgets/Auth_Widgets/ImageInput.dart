import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//Utils
import '../../Utils/Constants.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  const ImageInput(this.setImage, {super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? imagePicked;
  void chooseSourse() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Choose"),
            content: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton.icon(
                        onPressed: () async {
                          await pickImage(ImageSource.camera)
                              .then((value) => Navigator.of(_).pop());
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text("Camera")),
                    TextButton.icon(
                        onPressed: () async {
                          await pickImage(ImageSource.gallery)
                              .then((value) => Navigator.of(_).pop());
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("Gallery")),
                  ],
                )),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(_).pop(),
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  Future<void> pickImage(ImageSource source) async {
    var img = await ImagePicker()
        .pickImage(source: source, imageQuality: 50, maxWidth: 150);
    if (img != null) {
      imagePicked = File(img.path);
      widget.setImage(imagePicked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        chooseSourse();
      },
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 60,
            backgroundImage: imagePicked == null
                ? const AssetImage(profileImageAsset)
                : FileImage(imagePicked!) as ImageProvider,
          ),
          const Positioned(
            bottom: 10,
            right: 10,
            child: Icon(
              Icons.add_a_photo_rounded,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
