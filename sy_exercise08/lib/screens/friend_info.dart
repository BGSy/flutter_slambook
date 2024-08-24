/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  Improvement of previous exercise, now implements a provider which manages 
  the state of the widgets and integration to Firebase to save data towards 
  the cloudfire database. This program is the widget for the Friend info screen 
  which will display info about a friend created by the user in the slambook 
  screen/form widget when clicked from the friend list screen.
*/

import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:sy_exercise08/provider/slambook_provider.dart';
import '../models/friend_arguments.dart';

class FriendsInfo extends StatelessWidget {

  static const routename = '/info'; // Route for the friends info screen
  const FriendsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    FriendArguments toView = context.read<Slambook>().view;
    return Scaffold(
      drawer: Drawer( // Drawer menu, where a user can choose the Friends or Slambook screen
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 50),
            ListTile(
              title: const Text('Friends', style: TextStyle(color: Colors.black),),
              onTap: () {
                Navigator.pushNamed(context, '/friends');
              },
            ),
            ListTile(
              title: const Text('Slambook', style: TextStyle(color: Colors.black),),
              onTap: () {
                Navigator.pushNamed(context, '/slambook');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(toView.name),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
          /*
            This is essentially a copy of the showSummary function used in the slambook widget
          */
          SizedBox(height: 200, width: 300, 
            child: ListView( // Uses listview builder to properly iterate through the formValue map and display its contents
              physics : const NeverScrollableScrollPhysics(), 
               children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text("Name:", style: TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                        Expanded(child: Text(toView.name, style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text("Nickname:", style: TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                        Expanded(child: Text(toView.nickName, style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text("Age:", style: TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                        Expanded(child: Text("${toView.age}", style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text("Relationship:", style: TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                        Expanded(child: Text("${toView.relationship}", style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text("Happiness:", style: TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                        Expanded(child: Text("${toView.happiness}", style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text("Superpower:", style: TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                        Expanded(child: Text(toView.power, style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                     Row(
                      children: [
                        const Expanded(child: Text("Motto:", style: TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                        Expanded(child: Text(toView.motto, style: const TextStyle(fontStyle: FontStyle.italic))),
                      ],
                    ),
                  ],
                ),
              ],
            )),
            TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Return to Friendlist"))
          ],
        ),
      ),
    );
  }
}