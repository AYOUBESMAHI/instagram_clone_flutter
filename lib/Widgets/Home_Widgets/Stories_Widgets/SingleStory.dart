import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';
//Model
import '../../../Models/Story.dart';

class SingleStory {
  final List<Story> stories;
  const SingleStory(this.stories);
  Widget _createDummyPage({
    required String text,
    required String imageName,
  }) {
    return StoryPageScaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey,
        child: Image.network(
          imageName,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildButtonText(String text) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildButtonDecoration(BuildContext ctx) {
    return BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(stories[0].profileImage), fit: BoxFit.cover));
  }

  BoxDecoration _buildBorderDecoration(Color color) {
    return BoxDecoration(
      shape: BoxShape.circle,
      border: Border.fromBorderSide(
        BorderSide(
          color: color,
          width: 2,
        ),
      ),
    );
  }

  StoryButtonData getStoryButtonData(BuildContext context) {
    return StoryButtonData(
      timelineBackgroundColor: Colors.purple,
      buttonDecoration: _buildButtonDecoration(context),
      child: _buildButtonText(''),
      borderDecoration: _buildBorderDecoration(Colors.pink),
      storyPages: [
        ...stories
            .map(
              (e) => _createDummyPage(
                text: '',
                imageName: e.media,
              ),
            )
            .toList(),
      ],
      segmentDuration: const Duration(seconds: 3),
    );
  }
}
