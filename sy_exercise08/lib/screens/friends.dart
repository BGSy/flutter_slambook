/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  Improvement of previous exercise, now implements a provider which manages 
  the state of the widgets and integration to Firebase to save data towards 
  the cloudfire database. This program is the widget for the Friends list 
  screen which will display the "friends" created by the user in the slambook 
  screen/form widget in a form of a list.
*/

import 'package:flutter/material.dart';
import 'friend_info.dart';
import '../models/friend_arguments.dart';
import "package:provider/provider.dart";
import 'package:sy_exercise08/provider/slambook_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'form_modal.dart';


List<Map<String,dynamic>>? localMaps;

class Friends extends StatelessWidget {

  static const routename = '/friends';
  const Friends({super.key});
  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot> friendlist = context.read<Slambook>().entries;
    return Scaffold(
      drawer: Drawer( // Drawer menu, where a user can choose the Friends or Slambook screen
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 50),
            ListTile(
              title: const Text('Friends', style: TextStyle(color: Colors.black),),
              onTap: () {
                Navigator.pushNamed(context, '/friends'); // Moves to the friends screen
              },
            ),
            ListTile(
              title: const Text('Slambook', style: TextStyle(color: Colors.black),),
              onTap: () {
                Navigator.pushNamed(context, '/slambook'); // Moves to the slambook screen
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Friends List'),
      ),
      body: Center(
        child: 
        SingleChildScrollView(child: Column(
          children: [
            const SizedBox(height: 25),
            showFriends(context),
            ElevatedButton( 
              child: const Text('Go to Slambook'),
              onPressed: () {
                Navigator.pushNamed(context, '/slambook');  // Moves to the slambook screen
              },
            ),
          ],
        )
      ),
    ));
  }

  /*
  Uses a listview to display the friends that the user created
  A TextButton was utilized so that when the names are clicked
  It leads to a new page showing info about the friend that was
  clicked.
  */
  Widget showFriends(BuildContext context){
    Stream<QuerySnapshot> friendlist = context.watch<Slambook>().entries;
    return Padding( 
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        const Text("Friends\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 400, width: 300, 
          child: StreamBuilder( // Uses listview builder to properly iterate through the list of maps representing each friend and display their name
          stream: friendlist,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              print("snapshot no data");
              return const Center(
                child: Text("No Friends Found", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
              );
            } else {
            return ListView.builder(
              physics : const NeverScrollableScrollPhysics(), 
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index){
                FriendArguments friend = FriendArguments.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>
                );
                return Row(children: [
                  Expanded(child: 
                  TextButton( 
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 0, 0, 0)), 
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 243, 231, 63), 
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(0)
                      )),
                    ),
                    onPressed: (){ // When the button is pressed, navigates to the screen displaying info about the friend
                      context.read<Slambook>().viewFriend(friend);
                      Navigator.pushNamed(context, FriendsInfo.routename); 
                    },
                    // Display the name of the friend
                    child: Text(friend.name, style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                  ),),
                   IconButton(
                    onPressed: () {
                      context.read<Slambook>().viewFriend(friend);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const FormModal(
                          type: 'Edit',
                        ),
                      );
                    },
                    icon: const Icon(Icons.create_outlined, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<Slambook>().viewFriend(friend);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const FormModal(
                            type: 'Delete',
                          ),
                      );
                    },
                    icon: const Icon(Icons.delete_outlined, color: Colors.white),
                  )
                ],);
              }
            ); }
          }
          )
        ),
      ]),
    );
  }
}
