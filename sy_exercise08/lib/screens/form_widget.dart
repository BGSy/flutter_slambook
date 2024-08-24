/*
  Author: Benedict Gabriel Sy
  Created date: May 8, 2023
  Section: CMSC 23 B-2L

  Improvement of previous exercise, now implements a provider which manages 
  the state of the widgets and integration to Firebase to save data towards 
  the cloudfire database. This program is the widget for the slambook screen, 
  and has a few additions from the previous exercise which includes a floating 
  action button to add a friend in the friends list screen.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Used for input formatting in age text field
import "package:provider/provider.dart";
import 'package:sy_exercise08/models/friend_arguments.dart';
import 'package:sy_exercise08/provider/slambook_provider.dart';
import 'friends.dart';

class FormWidget extends StatefulWidget {
  static const routename = '/slambook';
  const FormWidget({super.key});

  @override
  _FormWidgetState createState() => _FormWidgetState();
}
List<Map<String,dynamic>> maps = [];
class _FormWidgetState extends State<FormWidget> {

  bool light = false;  // Default value for relationship status switch
  bool showSum = false; // Default value for showSum
  double _currentSliderValue = 5; // Default value for happiness slider

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

  String _radio = _motto.keys.elementAt(0); // Default value for motto radio

  Map<String, dynamic> formValues = {
    'Name': "",
    'Nickname': "",
    'Age': "",
    'In a relationship': false,
    'Happiness Level': 5,
    'Superpower': _powerOptions.first, // Default value for super power
    'Motto in life': _motto.keys.elementAt(0),
  };

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
        title: const Text('Slambook'),
      ), resizeToAvoidBottomInset: false,
      body: ListView(children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Sort of like the title of the app
              Padding(
                padding: const EdgeInsets.all(30),
                child: Stack(
                  children:[ 
                    const Text("SLAMBOOK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Color.fromARGB(255, 243, 231, 63), letterSpacing: 3, fontFamily: "Cyberway Riders")),
                    Text("SLAMBOOK", style: TextStyle(fontSize: 40, letterSpacing: 3,
                    foreground: Paint() // Used to outline the text
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.cyan, fontFamily: "Cyberway Riders"))
                  ]
                ),
              ),
              const Divider(
                thickness: 3,
                color: Colors.cyan,
              ),

              // Name Text field #########
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 243, 231, 63), width: 2.0),
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Enter Name",
                    labelText: "Name",
                    errorStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (String value) {
                    formValues["Name"] = value; // Store value to its respective field in the formValue map
                  },
                  // Validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
              ),

              // Nickname Text Field ##############
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Color.fromARGB(255, 243, 231, 63), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      hintText: "Enter Nickname",
                      labelText: "Nickname",
                      errorStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (String value) {
                    formValues["Nickname"] = value;  // Store value to its respective field in the formValue map
                  },
                  // Validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter nickname';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // Age Text Field ##########
                  Container(
                    padding: const EdgeInsets.all(10), 
                    width: 150,
                    child: TextFormField(
                      keyboardType: TextInputType.number, // Displays the numpad instead of the normal keyboard
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly], // Used to ensure that only digits are accepted by the form field
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 243, 231, 63), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: "Enter Age",
                        labelText: "Age",
                        errorStyle: TextStyle(color: Colors.white),
                      ),
                      onChanged: (String value) {
                        formValues["Age"] = value;  // Store value to its respective field in the formValue map
                      },
                      // Validation
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                          return null;
                      },
                    ),
                  ),

                  // Relationship status Switch ############
                  const Text("In a relationship?"),
                  Switch(
                    value: light,
                    activeColor: Colors.cyan,
                    inactiveTrackColor: const Color.fromARGB(255, 243, 231, 63),
                    onChanged: (bool value) {
                      setState(() {
                        formValues["In a relationship"] = value;  // Store value to its respective field in the formValue map
                        light = value; // Re-renders the switch
                      });
                    },
                  )
              ]),

              const Divider(
                    thickness: 1,
                    color: Colors.cyan,
              ),

              // Happiness level Slider ##########
              Column( children:[
                const Center(child: Text("Happiness Meter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),),
                const Center(child: Text("From 1 to happy, how happy are you?", style: TextStyle(fontStyle: FontStyle.italic)),),
                Slider(
                  value: _currentSliderValue, // There will be decimal values for the slider, to make it more accurate and smooth
                  activeColor: const Color.fromARGB(255, 243, 231, 63),
                  max: 10,
                  divisions: 100, // Decimal values will appear
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                      formValues["Happiness Level"] = value;
                    });
                  },
                ),
              ]),

              // Superpowers Drop down #############
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("Superpower", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text("If you were to choose a super power, which one would you choose?"),
              ),
              Container(padding: const EdgeInsets.all(10), 
                decoration: const BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
                child: 
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color.fromARGB(255, 0, 0, 0),
                    value: formValues["Superpower"],
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        formValues["Superpower"] = value!;
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

              const Divider(
                    thickness: 1,
                    color: Colors.cyan,
              ),

              // Motto Radio ##########
              const Padding(
                padding: EdgeInsets.all(30),
                child: Text("Motto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              SizedBox( // Used to prevent unbounded error
                height: 450,
                  child: ListView.builder( // Used list view builder to build a ListTile Widget which is used for radio buttons
                    physics : const NeverScrollableScrollPhysics(), // Used to be able to smoothly scroll within radio buttons
                    itemCount: _motto.keys.length,
                    itemBuilder: (BuildContext context, int index){ // Iterate through each key in the _motto map
                      return ListTile(
                        title: Text(_motto.keys.elementAt(index), style: const TextStyle(color: Colors.white)),
                        leading: Radio( 
                          value: _motto.keys.elementAt(index), 
                          groupValue: _radio, 
                          fillColor: WidgetStateColor.resolveWith((states) => const Color.fromARGB(255, 243, 231, 63)),
                          onChanged: (String? value){
                            setState(() {
                              formValues["Motto in life"] = value!;
                              _radio = value;
                            });
                          },
                        ),
                      );
                    }
                )
              ),

              // Submit button
              ElevatedButton(
                onPressed: () {
                    if (_formKey.currentState!.validate()) { // Checks if fields are populated
                      _formKey.currentState?.save();
                      setState(() {
                        showSum = true; // Used to alert showSummary
                      });
                    }
                },
                child: const Text('Submit'),
              ),

              showSum ? showSummary(): const SizedBox(), // Shows summary when validation is successful

              const Divider(
                thickness: 1,
                color: Color.fromARGB(255, 243, 231, 63),
              ), 
              
              // Resets button
              ElevatedButton(
                onPressed: () {
                    _formKey.currentState?.reset(); // Resets the text fields
                    setState(() { // Sets the state of other widgets by updating its value in formValue, and resetting their basis values
                      formValues["In a relationship"] = false;
                      light = false;
                      formValues["Happiness Level"] = 5;
                      _currentSliderValue = 5;
                      formValues["Superpower"] = _powerOptions.first;
                      formValues["Motto in life"] = _motto.keys.elementAt(0);
                      _radio = _motto.keys.elementAt(0);
                      showSum = false;
                    });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton( // Floating action button used to add a friend to the friends list
        onPressed: (){
          showSum ? addPerson() : const SizedBox(); // Only adds the friend to the friends list when user sucessfully submits the form
        },
        child: const Icon(Icons.account_circle_sharp),
      ),
    );
  }

  // Function that navigates to the friend list screen when a new friend is added
  void addPerson(){

    FriendArguments temp = FriendArguments(
      name: formValues.values.elementAt(0), 
      nickName: formValues.values.elementAt(1), 
      age: int.parse(formValues.values.elementAt(2)), 
      relationship: formValues.values.elementAt(3), 
      happiness: formValues.values.elementAt(4), 
      power: formValues.values.elementAt(5), 
      motto: formValues.values.elementAt(6)
    );
    context.read<Slambook>().addFriend(temp);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${formValues['Name']} added!"),
      duration: const Duration(seconds: 1, milliseconds: 100),
    ));
    Navigator.pushNamed(context, Friends.routename);
  } 

  // Widget to showSummary
  Widget showSummary(){
    return Padding( 
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(child: Column(children: [
        const Text("Summary\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 200, width: 300, 
          child: ListView.builder( // Uses listview builder to properly iterate through the formValue map and display its contents
            physics : const NeverScrollableScrollPhysics(), 
            itemCount: formValues.keys.length,
            itemBuilder: (BuildContext context, int index){
              return Row(children: [
                Expanded(child: Text(formValues.keys.elementAt(index), style: const TextStyle(fontWeight: FontWeight.bold))), // Expanded to properly space it
                Expanded(child: Text("${formValues.values.elementAt(index)}", style: const TextStyle(fontStyle: FontStyle.italic))),
              ],);
            },
          )
          ),
      ],),));
  }

}
