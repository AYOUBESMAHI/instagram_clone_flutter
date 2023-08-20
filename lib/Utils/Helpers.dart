import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Future<void> chooseSourse(BuildContext context, Function pickmedia) async {
  await showDialog(
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
                        await pickmedia(ImageSource.camera)
                            .then((value) => Navigator.of(_).pop());
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text("Camera")),
                  TextButton.icon(
                      onPressed: () async {
                        await pickmedia(ImageSource.gallery)
                            .then((value) => Navigator.of(_).pop());
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Gallery")),
                ],
              )),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"))
          ],
        );
      });
}

Widget buildAlertDialog(
    BuildContext _, Function pickVideo, Function pickImage) {
  return AlertDialog(
    title: const Text("Choose"),
    content: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton.icon(
                onPressed: () {
                  chooseSourse(_, pickImage).then((value) => Navigator.pop(_));
                },
                icon: const Icon(Icons.image),
                label: const Text("Image")),
            TextButton.icon(
                onPressed: () {
                  chooseSourse(_, pickVideo).then((value) => Navigator.pop(_));
                },
                icon: const Icon(Icons.videocam),
                label: const Text("Video")),
          ],
        )),
    actions: [
      TextButton(
          onPressed: () => Navigator.of(_).pop(), child: const Text("Cancel"))
    ],
  );
}

bool isDateBefore24Hours(DateTime date) {
  DateTime currentDate = DateTime.now();
  Duration difference = currentDate.difference(date);
  return difference.inHours < 24;
}

bool isEmailValid(String email) {
  // Regular expression to check email format
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegExp.hasMatch(email);
}

bool isUsernameValid(String username) {
  // Regular expression to check username format
  final usernameRegExp = RegExp(r'^[a-zA-Z0-9_-]{3,16}$');
  return usernameRegExp.hasMatch(username);
}

bool isPasswordValid(String password) {
  // Regular expression to check password format
  final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  return passwordRegExp.hasMatch(password);
}

String? containsSameId(List<Map<String, dynamic>> list1,
    List<Map<String, dynamic>> list2, String key) {
  for (var map1 in list1) {
    var userId1 = map1[key];
    if (userId1 != null) {
      for (var map2 in list2) {
        var userId2 = map2[key];
        if (userId2 != null && userId1 == userId2) {
          return userId2;
        }
      }
    }
  }
  return null;
}

List<Map<String, dynamic>> containsUsername(
    List<Map<String, dynamic>> list1, String value) {
  List<Map<String, dynamic>> featched = [];
  for (var map1 in list1) {
    for (var p in map1["participants"]) {
      print('++++++ $p');
      if (p["username"].toString().contains(value.toLowerCase())) {
        featched.add(map1);
      }
    }
  }
  print("$value =====> ${featched.length}");
  return featched;
}

String formatTimeDifference(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return "${difference.inSeconds} seconds ago";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else {
    return DateFormat("dd MMM yyyy").format(dateTime);
  }
}
