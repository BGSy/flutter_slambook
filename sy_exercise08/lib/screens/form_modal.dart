/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  An additional code used to handle the delete and edit entry functions in the
  friendlist. This code makes use of an alert dialog to display the action
  that the user wants to do which is either to edit or delete an entry.
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/friend_arguments.dart';
import '../provider/slambook_provider.dart';
import 'package:flutter/services.dart'; 

class FormModal extends StatefulWidget {
  final String type;

  const FormModal({
    super.key,
    required this.type,
  });


  @override
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {


  static final List<String> _powerOptions = [
    "Makalipad",
    "Maging Invisible",
    "Mapaibig siya",
    "Mapabago ang isip niya",
    "Mapalimot siya",
    "Mabalik ang nakaraan",
    "Mapaghiwalay sila",
    "Makarma siya",
    "Mapasagasaan siya sa pison",
    "Mapaitim ang tuhod ng iniibig niya"
  ];

  static final Map<String, bool> _motto = {
    "Haters gonna hate": true,
    "Bakers gonna Bake": false,
    "If cannot be, borrow one from three": false,
    "Less is more, more or less": false,
    "Better late than sorry": false,
    "Don't talk to strangers when your mouth is full": false,
    "Let's burn the bridge when we get there": false
  };

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (widget.type) {
      case 'Edit':
        return const Text("Edit friend");
      case 'Delete':
        return const Text("Delete friend");
      default:
        return const Text("");
    }
  }

  String age = "";

  Widget _buildContent(BuildContext context) { // Used for the visual elements seen in the alert dialog
    FriendArguments friend = context.read<Slambook>().view;
    switch (widget.type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${friend.name}'?",
          );
        }
      default:
        return Form(
          child:SingleChildScrollView(child: Column(mainAxisSize : MainAxisSize.min, children:[
            TextFormField(
              decoration: InputDecoration(
                hintText: friend.nickName,
                labelText: "Edit Nickname",
              ),
              onChanged: (String value) {
                setState(() {
                  friend.nickName = value;  // Store value to its respective field in the formValue map
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter nickname';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number, // Displays the numpad instead of the normal keyboard
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly], // Used to ensure that only digits are accepted by the form field
              decoration:  InputDecoration(
                hintText: "${friend.age}",
                labelText: "Edit Age",
                errorStyle: const TextStyle(color: Colors.white),
              ),
              onChanged: ( value) {
                setState(() {
                   age = value;  // Store value to its respective field in the formValue map
                });
              },
              // Validation
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter age';
                }
                  return null;
              },
            ),
            const Divider(
                thickness: 3,
                color: Color.fromARGB(255, 0, 0, 0),
            ), 
            const Text("In a relationship?"),
            Switch(
              value:  friend.relationship,
              activeColor: Colors.cyan,
              inactiveTrackColor: const Color.fromARGB(255, 243, 231, 63),
              onChanged: (bool value) {
                setState(() {
                   friend.relationship = value;  // Store value to its respective field in the formValue map
                });
              },
            ),
            Column( children:[
              const Center(child: Text("Happiness Meter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),),
              const Center(child: Text("From 1 to happy, how happy are you?", style: TextStyle(fontStyle: FontStyle.italic)),),
              Slider(
                value:  friend.happiness.toDouble(), // There will be decimal values for the slider, to make it more accurate and smooth
                max: 10,
                divisions: 100, // Decimal values will appear
                label:  friend.happiness.round().toString(),
                onChanged: (double value) {
                  setState(() {
                     friend.happiness = value;
                  });
                },
              ),
            ]),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Superpower", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Container(padding: const EdgeInsets.all(10), 
              decoration: const BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
              child: 
              DropdownButtonFormField<String>(
                isExpanded: true,
                dropdownColor: const Color.fromARGB(255, 0, 0, 0),
                value:  friend.power,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                     friend.power= value!;
                  });
                },
                items: _powerOptions.map<DropdownMenuItem<String>>( // Obtains the items for the superpowers from _powerOptions list
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value), // Displays each item thru the text widget
                    );
                  },
                ).toList(),
                onSaved: (newValue) {
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text("Motto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),

            ListView.builder( // Used list view builder to build a ListTile Widget which is used for radio buttons
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics : const NeverScrollableScrollPhysics(), // Used to be able to smoothly scroll within radio buttons
              itemCount: _motto.keys.length,
              itemBuilder: (BuildContext context, int index){ // Iterate through each key in the _motto map
                return ListTile(
                  title: Text(_motto.keys.elementAt(index), style: const TextStyle(color: Colors.white)),
                  leading: Radio( 
                    value: _motto.keys.elementAt(index), 
                    groupValue:  friend.motto, 
                    fillColor: WidgetStateColor.resolveWith((states) => const Color.fromARGB(255, 243, 231, 63)),
                    onChanged: (String? value){
                      setState(() {
                       friend.motto = value!;
                      });
                    },
                  ),
                );
              }
            )

          ])
        ));
    }
  }

  TextButton _dialogAction(BuildContext context) { // Used to determine the action that the user wants to do

    FriendArguments friend = context.read<Slambook>().view;
    return TextButton(
      onPressed: () {
        switch (widget.type) {
          case 'Edit':
            {
              friend.age = int.parse(age);
              context
                .read<Slambook>()
                .editFriend(friend.id!, friend);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context
                .read<Slambook>()
                .removeFriend(friend.id!);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(widget.type),
    );
  }
  @override
  Widget build(BuildContext context) { // Builds the Alert dialog
     return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 49, 46, 46),
      title: _buildTitle(),
      content: StatefulBuilder(builder: (context, state) => SizedBox(width: double.maxFinite, child: _buildContent(context))),

      // Contains two buttons - edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  } 
}