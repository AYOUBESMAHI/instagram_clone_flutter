class Post {
  late String postId;
  late String author;
  late List<Map<String, String>> media;
  late String caption;
  late List<String> likes;
  late List<Map<String, String>> comments;
  late DateTime timestamp;
  Post(
    this.postId,
    this.author,
    this.media,
    this.caption,
    this.likes,
    this.comments,
    this.timestamp,
  );

  Post.mapToPost(Map<String, dynamic> map) {
    postId = map["postId"];
    author = map["author"];
    media = (map["media"] as List)
        .map((e) =>
            {"type": e["type"].toString(), "media": e['media'].toString()})
        .toList();
    caption = map["caption"];
    likes = [...map["likes"]];
    comments = (map["comments"] as List)
        .map((e) => {
              "id": e["id"].toString(),
              "username": e["username"].toString(),
              "profileImage": e["profileImage"].toString(),
              "comment": e['comment'].toString()
            })
        .toList();
    timestamp = DateTime.parse(map["timestamp"]);
  }

  Map<String, dynamic> posttoMap() {
    return {
      "postId": postId,
      "author": author,
      "media": media,
      "caption": caption,
      "likes": likes,
      "comments": comments,
      "timestamp": timestamp.toIso8601String(),
    };
  }
}
