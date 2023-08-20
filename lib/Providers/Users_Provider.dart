import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Services/firebase_firestore_service.dart';

class UsersProvider extends ChangeNotifier {
  List<User> searchedUsers = [];
  final _firebase = FirebaseFirestoreService();
  Future<void> fetchUsers(String query) async {
    searchedUsers = [];
    searchedUsers = await _firebase.getSeachedUsers(query);

    notifyListeners();
  }

  Future<List<User>> fetchUsersIds(List<String> ids) async {
    List<User> users = [];
    for (var id in ids) {
      users.add(await _firebase.getUser(id));
    }

    return users;
  }

  Future<User> fetchUserId(String id) async {
    User user = await _firebase.getUser(id);

    return user;
  }

  void clearSearch() {
    searchedUsers = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
