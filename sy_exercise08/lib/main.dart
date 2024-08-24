/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  Improvement of exercise 05, now implements a provider which manages the state of the widgets
  and integration to Firebase to save data towards the cloudfire database.
*/

import 'package:flutter/material.dart';
import 'package:sy_exercise08/provider/slambook_provider.dart';
import 'package:sy_exercise08/screens/friends.dart';
import 'screens/form_widget.dart';
import 'screens/friend_info.dart';
import "package:provider/provider.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async { // Run App now runs a Material App by itself
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Slambook()),
  ], child: const MyApp()));
  
}
    
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Basics',
      theme: ThemeData( // Used for UI design purposes
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        inputDecorationTheme: const InputDecorationTheme(  
          labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
          hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
        ),
        primaryTextTheme: Typography(platform: TargetPlatform.android).white,
        textTheme: Typography(platform: TargetPlatform.android).white,
        ),
      // Routes to be used to navigate screens
      initialRoute: '/friends',
      routes: {
        '/friends': (context) => const Friends(),
        '/slambook': (context) => const FormWidget(),
        '/info' : (context) =>const FriendsInfo(),
      },
    );
  }

}
