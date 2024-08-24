/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  Improvement of previous exercise, now implements a provider which manages 
  the state of the widgets and integration to Firebase to save data towards 
  the cloudfire database. This dart program is simply the class used by the 
  provider to create and send a copy of a friend's information that will 
  be displayed in the Friends info screen.
*/
import 'dart:convert';

class FriendArguments {
  final String name;
  String nickName;
  num age;
  bool relationship;
  num happiness;
  String power;
  String motto;
  String? id;
  
  FriendArguments ({ // Constructor
    this.id,
    required this.name,
    required this.nickName,
    required this.age,
    required this.relationship,
    required this.happiness,
    required this.power,
    required this.motto
  });

  factory FriendArguments.fromJson(Map<String, dynamic> json) { // Convert the json object to a class object to be manipulated in the app
    return FriendArguments(
      name: json['name'],
      nickName: json['nickName'],
      age: json['age'],
      id: json['id'],
      relationship: json['relationship'],
      happiness: json['happiness'],
      power: json['power'],
      motto: json['motto']
    );
  }

  static List<FriendArguments> fromJsonArray(String jsonData) { 
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<FriendArguments>((dynamic d) => FriendArguments.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(FriendArguments map) { // Convert the class object to a json object to be saved to the database
    return {
      'name': map.name,
      'nickName': map.nickName,
      'age': map.age,
      'relationship': map.relationship,
      'happiness': map.happiness,
      'power': map.power,
      'motto': map.motto
    };
  }

}
