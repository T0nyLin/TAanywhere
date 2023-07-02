import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/screens/setting.dart';
import 'package:ta_anywhere/widget/qr_code.dart';
import 'package:ta_anywhere/widget/widget_tree.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = Auth().currentUser;
  String newModule = '';

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        signOut();
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Logged out successfully'),
          ));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WidgetTree()),
          (route) => false,
        );
      },
      child: const Text("Log Out"),
    );
  }

  Widget _settingButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: IconButton(
        icon: const Icon(Icons.settings),
        iconSize: 40,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingScreen()),
          );
        },
      ),
    );
  }

  Widget _qrCodeButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: IconButton(
        icon: const Icon(Icons.qr_code),
        iconSize: 40,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: ((context) => QRcode())));
        },
      ),
    );
  }

  Widget _mentorRank() {
    return const Text(
      'Year 2',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _ratingStars(int score) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData starIcon = i < score ? Icons.star : Icons.star_border;
      Widget star = Icon(starIcon, color: Colors.amber);
      stars.add(star);
    }
    return Row(children: stars);
  }

  Widget _moduleBox(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showAddModuleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Module'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                newModule = value;
              });
            },
            decoration: const InputDecoration(hintText: 'Enter a module'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                 // Get the user's ID
                String userId = user?.uid ?? '';

                // Get the current list of modules for the user from Firestore
                CollectionReference modulesRef = FirebaseFirestore.instance.collection('modules');
                modulesRef.doc(userId).get().then((snapshot) {
                  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

                  // Extract the modules list from the data
                  List<dynamic>? modules = data?['modules'] as List<dynamic>?;
                  if (modules == null) {
                    modules = [];
                  }

                  // Add the new module to the list
                  modules.add(newModule);

                  // Update the list of modules in Firestore for the user
                  modulesRef.doc(userId).set({'modules': modules});
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget _myModulesHeader() {
    return Row(
      children: [
        Text(
          'My Modules this Sem:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            _showAddModuleDialog(context);
          },
          child: const Text('Add Module'),
        ),
      ],
    );
  }

  Widget _myModulesList(List<dynamic> modules) {
    if (modules.isEmpty) {
      return const Text('No modules added.');
    }

    List<Widget> moduleRows = [];
    List<Widget> currentRow = [];

    for (int i = 0; i < modules.length; i++) {
      Widget moduleBox = GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmation'),
                content: const Text('Are you sure you want to remove this module?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Remove'),
                    onPressed: () {
                      setState(() {
                        // Remove the module from the list
                        modules.removeAt(i);
                        
                        // Get the user's ID
                        String userId = user?.uid ?? '';

                        // Update the list of modules in Firestore for the user
                        CollectionReference modulesRef = FirebaseFirestore.instance.collection('modules');
                        modulesRef.doc(userId).set({'modules': modules});
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: _moduleBox(modules[i]),
      );
      currentRow.add(moduleBox);
      currentRow.add(SizedBox(width: 10));

      // Check if four modules have been added to the current row
      if (currentRow.length == 8 || i == modules.length - 1) {
        moduleRows.add(Row(
          children: currentRow,
          mainAxisAlignment: MainAxisAlignment.start,
        ));
        moduleRows.add(SizedBox(height: 10));
        currentRow = [];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align rows to the left
      children: moduleRows,
    );
  }



@override
Widget build(BuildContext context) {
  // Get the user's ID
  String userId = user?.uid ?? '';

  return Scaffold(
    body: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('modules')
          .doc(userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;

          // Extract the modules list from the data
          List<dynamic>? modules = data?['modules'] as List<dynamic>?;

          if (modules == null) {
            modules = [];
          }
          return Scrollbar(
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
                          child: Text(
                            'Mentor Rank:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                          child: _mentorRank(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 9.0),
                          child: Text(
                            'Rating:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                            child: _ratingStars(2), // Change the score here to test
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _settingButton(context),
                            const SizedBox(height: 40),
                            _qrCodeButton(context),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(
                              'assets/icons/profile_pic.png'), // Replace with user image from database soon
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _myModulesHeader(),
                      const SizedBox(height: 10),
                      _myModulesList(modules),
                      const SizedBox(height: 20),
                      Text(
                        'Modules I can help with:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: [
                          _moduleBox("MA1521"),
                          const SizedBox(width: 10),
                          _moduleBox("CS2040S"),
                          const SizedBox(width: 10),
                          _moduleBox("CS1231S"),
                          const SizedBox(width: 10),
                          _moduleBox("CS2030"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: [
                          _moduleBox("CS2100"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _userUid(),
                        _signOutButton(context),
                      ],
                    ),
                  
                    ],
                  ),
                ),
              ],
            ),
            )
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  );
}
}
