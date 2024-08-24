/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  This code is the controller for the Firebase API which enables the app to
  reflect changes towards the cloudfirestore database when the user wants
  to add, edit, fetch, or delete a friend's entry in the slambook.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend_arguments.dart';

class FirebaseSlambookAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addFriend(Map<String, dynamic> friend) async { // Future method to add a friend's entry towards the database
    try {
      final docRef = await db.collection("entries").add(friend);
      await db.collection("entries").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllFriends() { // Used to fetch the entries currently stored in the database
    return db.collection("entries").snapshots();
  }

  Future<String> editFriend(String? id, FriendArguments map) async { // Future method to edit a friend's entry in the database
    try {
      await db.collection("entries").doc(id).update({
        "name": map.name, 
        "nickName": map.nickName, 
        "age": map.age, 
        "relationship": map.relationship, 
        "happiness": map.happiness,
        "power": map.power,
        "motto": map.motto
      });

      return "Successfully edited entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> removeFriend(String? id) async {  // Future method to remove a friend's entry in the database
    try {
      await db.collection("entries").doc(id).delete();

      return "Successfully deleted entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}