import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:ta_anywhere/components/auth.dart';

import 'package:ta_anywhere/components/modulecode.dart';
import 'package:ta_anywhere/widget/picklocation.dart';
import 'package:ta_anywhere/widget/tabs.dart';

class EditnReUploadScreen extends StatefulWidget {
  const EditnReUploadScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<EditnReUploadScreen> createState() => _EditnReUploadScreenState();
}

class _EditnReUploadScreenState extends State<EditnReUploadScreen> {
  final User user = Auth().currentUser!;

  final _formKey = GlobalKey<FormState>();
  String _newQuery = '';
  static final _modController = TextEditingController();
  final _destinationController = TextEditingController();
  String _newLandmark = '';
  double x = 0.0;
  double y = 0.0;
  String? myToken = '';
  String cost = '';
  String level = '';
  bool isUploading = false;
  DateTime timenow = DateTime.now();
  String formatDate = DateFormat('ddMMyyHHmmss').format(DateTime.now());
  String menteeUsername = '';

  Widget _buildFileImage() {
    return GestureDetector(
      onTap: () {
        showImageViewer(
          context,
          CachedNetworkImageProvider(widget.data['image_url']),
          swipeDismissible: true,
          doubleTapZoomable: true,
        );
      },
      child: CachedNetworkImage(
        imageUrl: widget.data['image_url'].toString(),
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) =>
            const CircularProgressIndicator(
                color: Color.fromARGB(255, 48, 97, 104)),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        height: 50,
      ),
    );
  }

  @override
  void initState() {
    x = widget.data['x-coordinate'];
    y = widget.data['y-coordinate'];
    _modController..text = widget.data['module Code'];
    _destinationController..text = widget.data['location'];
    super.initState();
    getToken();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        myToken = token;
      });
    });
  }

  void _saveQuery(BuildContext context) async {
    isUploading = true;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance
          .collection('user queries')
          .doc(user.uid)
          .update({
        'mentee': menteeUsername,
        'menteeid': user.uid,
        'token': myToken,
        'query': _newQuery,
        'module Code': _modController.text,
        'cost': cost,
        'level': level,
        'location': _destinationController.text,
        'x-coordinate': x,
        'y-coordinate': y,
        'landmark': _newLandmark,
      });
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Query updated successfully'),
        ));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => TabsScreen()),
        (route) => false,
      );
      isUploading = false;
    } else {
      isUploading = false;
    }
    FocusScope.of(context).unfocus(); //close keyboard
  }

  Widget mediumLabel(String data) {
    return Text(
      data,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
    );
  }

  Widget getUserInfo(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return mediumLabel('Something went wrong');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return mediumLabel('Current user does not exists.');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          menteeUsername = data['username'];
          return ElevatedButton.icon(
            onPressed: () {
              _saveQuery(context);
            },
            icon: const Icon(Icons.file_upload_outlined),
            label: isUploading
                ? CircularProgressIndicator(
                    color: Color.fromARGB(255, 48, 97, 104),
                  )
                : Text(
                    'Re-Upload',
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
          );
        }

        return CircularProgressIndicator(
          color: Color.fromARGB(255, 48, 97, 104),
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   _destinationController.dispose();
  //   _modController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    String modNum = widget.data['module Code']
        .toString()
        .replaceAll(RegExp(r"\D"), ''); //remove letters from module code

    if (modNum[0] == '1') {
      level = '1000';
      cost = '\$4';
    } else if (modNum[0] == '2') {
      level = '2000';
      cost = '\$4';
    } else if (modNum[0] == '3') {
      level = '3000';
      cost = '\$5';
    } else if (modNum[0] == '4') {
      level = '4000';
      cost = '\$5';
    } else if (modNum[0] == '5') {
      level = '5000';
      cost = '\$6';
    } else if (modNum[0] == '6') {
      level = '6000';
      cost = '\$6';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Query'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  child: _buildFileImage(),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: widget.data['query'].toString(),
                  maxLength: 280,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What is your query?',
                    hintText: 'Describe your situation...',
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 280) {
                      return 'Must be between 1 and 280 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newQuery = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
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
                            hintText: widget.data['module Code'],
                            hintStyle: const TextStyle(
                                fontSize: 13, color: Colors.grey),
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
                            child: Text(
                              _modController.text = 'Module not found.',
                              style:
                                  Theme.of(context).primaryTextTheme.bodySmall,
                            ),
                          );
                        },
                        onSuggestionSelected: (ModuleCode? suggestion) {
                          final modcode = suggestion!;
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Selected mod code: ${modcode.modCode}'),
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
                    const Text('  ......................  '),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      width: 100,
                      height: 55,
                      child: Center(
                        child: Center(
                          child: Text(_modController.text == ''
                              ? 'Code'
                              : _modController.text),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    controller: _destinationController,
                    maxLines: 2,
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                    readOnly: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              PickLocation(onSelectLocation: (location) {
                            _destinationController.text =
                                location.address.toString();
                            x = location.longitude;
                            y = location.latitude;
                          }),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: const EdgeInsets.only(left: 10, right: 11),
                        width: 10,
                        height: 25,
                        child: const Icon(
                          Icons.place_outlined,
                          color: Colors.black,
                        ),
                      ),
                      hintText: widget.data['location'],
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please set your location';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    initialValue: widget.data['landmark'],
                    maxLines: 2,
                    maxLength: 200,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      prefixIcon: const Icon(
                        Icons.notes,
                        size: 30,
                      ),
                      labelText: 'Landmark',
                      hintText:
                          'Please describe a distinct landmark so that your mentor can find you easily.',
                      hintStyle:
                          const TextStyle(fontSize: 13, color: Colors.grey),
                      labelStyle: const TextStyle(fontSize: 10),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 200) {
                        return 'Must be between 1 and 200 characters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newLandmark = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                getUserInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
