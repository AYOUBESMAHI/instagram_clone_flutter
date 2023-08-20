import 'package:flutter/material.dart';

class EmptyPostsWidget extends StatelessWidget {
  final Function changePage;
  const EmptyPostsWidget(this.changePage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(32),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: Colors.black)),
            padding: const EdgeInsets.all(9),
            child: Image.asset(
              "Assets/Images/instagram-3814060_1280.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Welcome To Instagram Clone 😁 ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(
              "When you follow people, you'll see the photos and videos they post here. ",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => changePage(2),
                child: const Text(
                  "Find People To follow",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
          )
        ]),
      ),
    );
  }
}
