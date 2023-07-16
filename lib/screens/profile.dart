import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/queryTile.dart';
import 'package:ta_anywhere/components/textSize.dart';
import 'package:ta_anywhere/screens/setting.dart';
import 'package:ta_anywhere/widget/qr_code.dart';
import 'package:ta_anywhere/widget/widget_tree.dart';
import 'package:ta_anywhere/components/modulecode.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = Auth().currentUser;
  final _modController = TextEditingController();
  double avg = 0;
  File? _imageFile = null;
  String? _profilePicUrl;

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
    return IconButton(
      icon: const Icon(Icons.settings),
      iconSize: 40,
      color: Colors.black,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingScreen()),
        );
      },
    );
  }

  Widget _qrCodeButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.qr_code),
      iconSize: 40,
      color: Colors.black,
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => QRcode())));
      },
    );
  }

  Widget _mentorRank(num rater) {
    String rank = '';
    if (rater <= 2) {
      rank = 'Newcomer';
    } else if (rater <= 5) {
      rank = 'Beginner';
    } else if (rater <= 10) {
      rank = 'Average';
    } else if (rater <= 20) {
      rank = 'Talented';
    } else if (rater <= 35) {
      rank = 'Competent';
    } else if (rater <= 60) {
      rank = 'Proficient';
    } else if (rater <= 80) {
      rank = 'Master';
    } else {
      rank = 'Grand Master';
    }
    return largeLabel(rank, context);
  }

  Widget _ratingStars(num rater, num rating) {
    if (rater == 0.0) {
      return RatingBar(
        ratingWidget: RatingWidget(
          full: Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: Icon(
            Icons.star_outline,
          ),
        ),
        glow: false,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemSize: 22,
        minRating: 0,
        ignoreGestures: true,
        initialRating: 0,
        onRatingUpdate: (rating) {
          debugPrint(rating.toString());
        },
      );
    }

    avg = rating / rater;
    return RatingBar(
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: Colors.amber,
        ),
        half: Icon(
          Icons.star_half,
          color: Colors.amber,
        ),
        empty: Icon(
          Icons.star_outline,
        ),
      ),
      glow: false,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemSize: 30,
      minRating: 0,
      ignoreGestures: true,
      initialRating: avg,
      onRatingUpdate: (rating) {
        debugPrint(rating.toString());
      },
    );
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
          content: SizedBox(
            width: 150,
            child: TypeAheadFormField<ModuleCode?>(
              debounceDuration: const Duration(milliseconds: 500),
              textFieldConfiguration: TextFieldConfiguration(
                controller: _modController,
                maxLength: 7,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  prefixIcon: const Icon(
                    Icons.colorize_rounded,
                    size: 30,
                  ),
                  labelText: 'Search Modules',
                  hintText: 'Module Code',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  labelStyle: const TextStyle(fontSize: 9),
                  counterText: '',
                ),
              ),
              suggestionsCallback: getModCodes,
              itemBuilder: (context, ModuleCode? suggestion) {
                final modcode = suggestion!;
                return ListTile(
                  title: Text(modcode.modCode),
                );
              },
              noItemsFoundBuilder: (context) {
                return Center(
                  child: smallLabel(
                      _modController.text = 'Module not found.', context),
                );
              },
              onSuggestionSelected: (ModuleCode? suggestion) {
                final modcode = suggestion!;
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Selected mod code: ${modcode.modCode}'),
                    ),
                  );
                setState(() {
                  _modController.text = modcode.modCode;
                });
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 10 ||
                    value.trim() == 'Module not found.') {
                  setState(() {
                    _modController.clear();
                    _modController.text = '';
                  });
                  return 'Invalid Code';
                }
                return null;
              },
            ),
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
                CollectionReference modulesRef =
                    FirebaseFirestore.instance.collection('users');
                modulesRef.doc(userId).get().then((snapshot) {
                  Map<String, dynamic>? data =
                      snapshot.data() as Map<String, dynamic>?;

                  // Extract the modules list from the data
                  List<dynamic>? modules = data?['modules'] as List<dynamic>?;
                  if (modules == null) {
                    modules = [];
                  }

                  // Add the new module to the list
                  modules.add(_modController.text);

                  // Update the list of modules in Firestore for the user
                  modulesRef.doc(userId).update({'modules': modules});
                  _modController.text = '';
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddModuleDialogHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Module'),
          content: SizedBox(
            width: 150,
            child: TypeAheadFormField<ModuleCode?>(
              debounceDuration: const Duration(milliseconds: 500),
              textFieldConfiguration: TextFieldConfiguration(
                controller: _modController,
                maxLength: 7,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  prefixIcon: const Icon(
                    Icons.colorize_rounded,
                    size: 30,
                  ),
                  labelText: 'Search Modules',
                  hintText: 'Module Code',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  labelStyle: const TextStyle(fontSize: 9),
                  counterText: '',
                ),
              ),
              suggestionsCallback: getModCodes,
              itemBuilder: (context, ModuleCode? suggestion) {
                final modcode = suggestion!;
                return ListTile(
                  title: Text(modcode.modCode),
                );
              },
              noItemsFoundBuilder: (context) {
                return Center(
                  child: smallLabel(
                      _modController.text = 'Module not found.', context),
                );
              },
              onSuggestionSelected: (ModuleCode? suggestion) {
                final modcode = suggestion!;
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Selected mod code: ${modcode.modCode}'),
                    ),
                  );
                setState(() {
                  _modController.text = modcode.modCode;
                });
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 10 ||
                    value.trim() == 'Module not found.') {
                  setState(() {
                    _modController.clear();
                    _modController.text = '';
                  });
                  return 'Invalid Code';
                }
                return null;
              },
            ),
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
                CollectionReference modulesRef =
                    FirebaseFirestore.instance.collection('users');
                modulesRef.doc(userId).get().then((snapshot) {
                  Map<String, dynamic>? data =
                      snapshot.data() as Map<String, dynamic>?;

                  // Extract the modules list from the data
                  List<dynamic>? modules =
                      data?['modules_help'] as List<dynamic>?;
                  if (modules == null) {
                    modules = [];
                  }

                  // Add the new module to the list
                  modules.add(_modController.text);

                  // Update the list of modules in Firestore for the user
                  modulesRef.doc(userId).update({'modules_help': modules});
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
        largeLabel('My Modules this Sem:', context),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {
            _showAddModuleDialog(context);
          },
          icon: Icon(Icons.add_circle_rounded),
          color: Color.fromARGB(255, 92, 169, 179),
          iconSize: 40,
        )
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
                content:
                    const Text('Are you sure you want to remove this module?'),
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
                        CollectionReference modulesRef =
                            FirebaseFirestore.instance.collection('users');
                        modulesRef.doc(userId).update({'modules': modules});
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

  Widget _helpModulesHeader() {
    return Row(
      children: [
        largeLabel('Modules I can help with:', context),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {
            _showAddModuleDialogHelp(context);
          },
          icon: Icon(Icons.add_circle_rounded),
          color: Color.fromARGB(255, 92, 169, 179),
          iconSize: 40,
        )
      ],
    );
  }

  Widget _helpModulesList(List<dynamic> modules) {
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
                content:
                    const Text('Are you sure you want to remove this module?'),
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
                        CollectionReference modulesRef =
                            FirebaseFirestore.instance.collection('users');
                        modulesRef
                            .doc(userId)
                            .update({'modules_help': modules});
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

  Widget getQuery(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user queries')
            .doc(user!.uid)
            .snapshots(),
        builder: (ctx, usersnapshot) {
          if (usersnapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (!usersnapshot.hasData || !usersnapshot.data!.exists) {
            return Container();
          }
          if (usersnapshot.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }
          var data2 = usersnapshot.data!.data() as Map<String, dynamic>;
          var lifetime = lifetimeconversion(data2['lifetime']);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                largeLabel('My upload:', context),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black26),
                        borderRadius: BorderRadius.circular(8)),
                    child: itemTile(context, data2, lifetime)),
              ],
            ),
          );
        });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);

        // Get the user's ID
        String userId = user?.uid ?? '';

        // Generate a unique filename for the image
        String fileName = userId + '_' + path.basename(_imageFile!.path);

        // Call the existing _deleteProfilePic function to delete the previous profile picture
        _deleteProfilePic();

        // Upload the image file to Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child('profile_pictures').child(fileName);
        UploadTask uploadTask = storageRef.putFile(_imageFile!);

        // Monitor the upload task to get the download URL
        uploadTask.whenComplete(() {
          if (uploadTask.snapshot.state == TaskState.success) {
            storageRef.getDownloadURL().then((imageUrl) {
              // Update the user's document in Firestore with the download URL of the image
              CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
              usersRef.doc(userId).update({'profile_pic': imageUrl});
            });
          }
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _deleteProfilePic() async {
    // Get the user's ID
    String userId = user?.uid ?? '';

    // Get the current profile picture URL from Firestore
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

    // Check if the user data and profile picture URL exist
    if (userData != null && userData.containsKey('profile_pic')) {
      String? profilePicUrl = userData['profile_pic'];

      // Delete the profile picture file from Firebase Storage
      if (profilePicUrl != null) {
        Reference storageRef = FirebaseStorage.instance.refFromURL(profilePicUrl);
        await storageRef.delete();
      }
    }

    // Update the user's document in Firestore to remove the profile picture URL
    usersRef.doc(userId).update({'profile_pic': null});

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Changed Successfully'),
    ));
  }



  Widget _editButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _pickImage(); // Activate the image picker
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text('Are you sure you want to remove the profile picture?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Remove'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteProfilePic(); // Delete the profile picture
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Get the user's ID
    String userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: largeLabel('My Rank', context),
        actions: [_qrCodeButton(context), _settingButton(context)],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data =
                snapshot.data?.data() as Map<String, dynamic>?;

            // Extract the modules list from the data
            List<dynamic>? modules = data?['modules'] as List<dynamic>?;

            if (modules == null) {
              modules = [];
            }

            List<dynamic>? modules_help =
                data?['modules_help'] as List<dynamic>?;

            if (modules_help == null) {
              modules_help = [];
            }

            data!['rater'] == 0
                ? avg = 0
                : avg = data['rating'] / data['rater'];

            _profilePicUrl = data['profile_pic']; // Update the profile picture URL

            return Scrollbar(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            largeLabel('Rank:', context),
                            _mentorRank(data['rater']),
                            SizedBox(
                              height: 20,
                            ),
                            (data['rater'] == 0 || data['rater'] == 1)
                                ? Text(
                                    '${data['rater']} RATING',
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  )
                                : Text(
                                    '${data['rater']} RATINGS', //PLURAL ratings
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                            Center(
                              child: Text(
                                '${avg.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            _ratingStars(
                              data['rater'],
                              data['rating'],
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: _profilePicUrl != null
                                ? NetworkImage(_profilePicUrl!)
                                    as ImageProvider<Object>
                                : AssetImage('assets/icons/profile_pic.png'),
                          ),
                          _editButton(context),
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
                        _helpModulesHeader(),
                        const SizedBox(height: 10),
                        _helpModulesList(modules_help),
                        const SizedBox(height: 20),
                        getQuery(context),
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
            ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 48, 97, 104),
              ),
            );
          }
        },
      ),
    );
  }
}
