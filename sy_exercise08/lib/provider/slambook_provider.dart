/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  This code is the provider which manages the state of all the widgets utilized in the screen.
  Methods to add, view, fetch, delete, and edit a friend's entry can be seen which accepts
  a FriendArguments class and passes it towards the Firebase API.
*/

import 'package:flutter/material.dart';
import '../models/friend_arguments.dart';
import '../api/firebase_slambook_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Slambook with ChangeNotifier {

  late FirebaseSlambookAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;

  Slambook() {
      firebaseService = FirebaseSlambookAPI();
      fetchFriends();
  }

  final List<FriendArguments> _friendlist = [];
  FriendArguments? _toView;
  List<FriendArguments> get entriess => _friendlist;
  FriendArguments get view => _toView!;


  fetchFriends() {
    _friendsStream = firebaseService.getAllFriends();
  }

  Stream<QuerySnapshot> get entries {
    fetchFriends();
    return _friendsStream;
  } 

  void addFriend(FriendArguments map) async {
    String message = await firebaseService.addFriend(map.toJson(map));
    print(message);
    notifyListeners();
  }

  void viewFriend(FriendArguments map){
    _toView = map;
    notifyListeners();
  }

  void editFriend(String id, FriendArguments map) async {
    String message = await firebaseService.editFriend(id, map);
    print(message);
    notifyListeners();
  }

  void removeFriend(String? id) async {
    String message = await firebaseService.removeFriend(id);
    print(message);
    notifyListeners();
  }
}