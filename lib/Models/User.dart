class User {
  late String id;
  late String email;
  late String username;
  late String profileImageUrl;

  List<String> followers = [];
  List<String> following = [];
  List<Map<String, String>> posts = [];
  List<Map<String, String>> postsLiked = [];
  List<Map<String, String>> postsSaved = [];
  List<Map<String, String>> stories = [];

  List<Map<String, String>> chatIds = [];

  User(
    this.id,
    this.username,
    this.profileImageUrl,
    this.email,
  );

  User.mapToUser(Map<String, dynamic> map) {
    id = map["id"];

    username = map["username"];

    profileImageUrl = map["profileImageUrl"];

    email = map["email"];

    chatIds = (map["chatIds"] as List)
        .map((e) => {
              'userId': e["userId"].toString(),
              'chatId': e['chatId'].toString()
            })
        .toList();

    followers = (map["followers"] as List).map((e) => e.toString()).toList();

    following = (map["following"] as List).map((e) => e.toString()).toList();
    postsLiked = (map["postsLiked"] as List)
        .map((e) => {
              'userId': e["userId"].toString(),
              'postId': e['postId'].toString()
            })
        .toList();
    postsSaved = (map["postsSaved"] as List)
        .map((e) => {
              'userId': e["userId"].toString(),
              'postId': e['postId'].toString()
            })
        .toList();

    posts = (map["posts"] as List)
        .map((e) =>
            {'postId': e["postId"].toString(), 'date': e['date'].toString()})
        .toList();

    stories = (map["stories"] as List)
        .map((e) =>
            {'storyId': e["storyId"].toString(), 'date': e['date'].toString()})
        .toList();
  }

  Map<String, dynamic> usertoMap() {
    return {
      "id": id,
      "username": username.toLowerCase(),
      "profileImageUrl": profileImageUrl,
      "email": email,
      "chatIds": chatIds,
      "followers": followers,
      "following": following,
      "postsSaved": postsSaved,
      "postsLiked": postsLiked,
      "posts": posts,
      "stories": stories,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.id == id;
  }
}
