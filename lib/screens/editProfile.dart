import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ta_anywhere/components/textSize.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = Auth().currentUser;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  String _gender = '';
  bool display = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Initialize the values for the other fields here if available
  }

  @override
  void dispose() {
    _emailController.dispose();
    _genderController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _fetchData() async {
    // Fetch the user profile data from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          _emailController.text = data['email'] ?? '';
          //  _genderController.text = data['gender'] ?? '';
          _gender = data['gender'] ?? '';
          _usernameController.text = data['username'] ?? '';
          display = data['displayPic'];
        });
      }
    }
  }

  void _saveChanges() async {
    // String gender =  _genderController.text;
    String gender = _gender;
    String username = _usernameController.text;
    bool displayPic = display;

    // Update the user profile data in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'gender': gender,
        'username': username,
        'displayPic': displayPic,
      });

      // Show a snackbar or navigate to another page to indicate the changes were saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully')),
      );
    } catch (e) {
      // Handle the error if the update operation fails
      print('Failed to save changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes')),
      );
    }
  }

  void showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          child: CupertinoPicker(
            itemExtent: 40.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                if (index == 0) {
                  _gender = 'Male';
                } else if (index == 1) {
                  _gender = 'Female';
                } else if (index == 2) {
                  _gender = 'Prefer Not To Tell';
                }
              });
            },
            children: [
              Text('Male'),
              Text('Female'),
              Text('Prefer Not To Tell'),
            ],
          ),
        );
      },
    );
  }

  void showGenderMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Male'),
              onTap: () {
                setState(() {
                  _gender = 'Male';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Female'),
              onTap: () {
                setState(() {
                  _gender = 'Female';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Prefer Not To Tell'),
              onTap: () {
                setState(() {
                  _gender = 'Prefer Not To Tell';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "Gender",
          labelStyle: TextStyle(
            color: Colors.black, // Set the label text color to black
          ),
        ),
        value: _gender,
        onChanged: (value) {
          setState(() {
            _gender = value!;
          });
        },
        items: const [
          DropdownMenuItem(
            value: 'Male',
            child: Text('Male'),
          ),
          DropdownMenuItem(
            value: 'Female',
            child: Text('Female'),
          ),
          DropdownMenuItem(
            value: 'Prefer not to tell',
            child: Text('Prefer not to tell'),
          ),
        ],
      ),
    );
  }

  Widget displayPic() {
    return SwitchListTile(
        title: mediumLabel('Allow others to see my Profile Picture', context),
        value: display,
        activeColor: Color.fromARGB(255, 48, 97, 104),
        inactiveThumbColor: Color.fromARGB(255, 48, 97, 104),
        inactiveTrackColor: Color.fromARGB(255, 115, 195, 208),
        onChanged: (bool value) {
          setState(() {
            display = value;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: largeLabel('Edit Profile', context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color:
                            Colors.black, // Set the label text color to black
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Email cannot be modified",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.black, // Set the label text color to black
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // TextField(
            //   controller: _genderController,
            //   decoration: InputDecoration(
            //     labelText: "Gender",
            //   ),
            // ),
            _buildGenderDropdown(),
            SizedBox(height: 16.0),
            displayPic(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
