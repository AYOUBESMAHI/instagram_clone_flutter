class Story {
  late String storyId;
  late String authorId;
  late String authorUsername;
  late String profileImage;

  late String media;
  late DateTime timestamp;
  Story(
    this.storyId,
    this.authorId,
    this.authorUsername,
    this.profileImage,
    this.media,
    this.timestamp,
  );

  Story.mapToStory(Map<String, dynamic> map) {
    storyId = map["storyId"];
    authorId = map["authorId"];
    authorUsername = map["authorUsername"];
    profileImage = map["profileImage"];
    media = map["media"];
    timestamp = DateTime.parse(map["timestamp"]);
  }

  Map<String, dynamic> storytoMap() {
    return {
      "storyId": storyId,
      "authorId": authorId,
      "authorUsername": authorUsername,
      "profileImage": profileImage,
      "media": media,
      "timestamp": timestamp.toIso8601String(),
    };
  }
}
