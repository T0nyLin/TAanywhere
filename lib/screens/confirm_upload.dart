import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/screens/search_mentor.dart';

class ConfirmUploadScreen extends StatefulWidget {
  const ConfirmUploadScreen({
    super.key,
    required this.image,
    required this.query,
    required this.modcode,
    required this.location,
    required this.landmark,
    required this.x,
    required this.y,
  });

  final File image;
  final String query;
  final String modcode;
  final String location;
  final String landmark;
  final double x;
  final double y;

  @override
  State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
}

class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
  final User user = Auth().currentUser!;
  String cost = '';
  String level = '';
  bool isUploading = false;
  DateTime timenow = DateTime.now();
  String formatDate = DateFormat('ddMMyyHHmmss').format(DateTime.now());

  String? myToken = '';

  Widget buildFileImage() => Image.file(
        widget.image,
        fit: BoxFit.cover,
      );

  @override
  void initState() {
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

  void uploadQuery() async {
    isUploading = true;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('query_images')
        .child('${user.uid}$formatDate.jpg');

    await storageRef.putFile(widget.image);
    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('user queries')
        .doc(user.uid)
        .set({
      'mentee': user.email,
      'uid': user.uid,
      'token': myToken,
      'image_url': imageUrl,
      'query': widget.query,
      'module Code': widget.modcode,
      'cost': cost,
      'level': level,
      'location': widget.location,
      'x-coordinate': widget.x,
      'y-coordinate': widget.y,
      'landmark': widget.landmark,
      'uploadedTime': timenow,
      'lifetime': timenow,
    });

    isUploading = false;
  }

  @override
  Widget build(BuildContext context) {
    String modNum = widget.modcode
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
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
              ),
              width: double.infinity,
              height: 200,
              child: buildFileImage(),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.query,
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                ),
                Text(
                  'Module Code: ${widget.modcode}',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                Text(
                  'Cost: $cost',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                Text(
                  'Level: $level',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.location,
                style: const TextStyle(color: Colors.black, fontSize: 19)),
            Text(
              'Landmark: ${widget.landmark}',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            const SizedBox(
              height: 30,
            ),
            if (isUploading)
              const Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 48, 97, 104),
                  ),
                ),
              ),
            if (!isUploading)
              ElevatedButton.icon(
                onPressed: () {
                  uploadQuery();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchMentorScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Confirm Upload'),
              ),
            const Text(
              'Note: Uploaded Queries will be removed from Browse after 60min.',
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
