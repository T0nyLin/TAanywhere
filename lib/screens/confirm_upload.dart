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
  });

  final File image;
  final query;
  final modcode;
  final location;
  final landmark;

  @override
  State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
}

class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
  final User? user = Auth().currentUser!;

  Widget buildFileImage() => Image.file(widget.image);

  @override
  Widget build(BuildContext context) {
    String modNum = widget.modcode
        .toString()
        .replaceAll(RegExp(r"\D"), ''); //remove letters from module code

    String cost = '';
    String level = '';
    bool isUploading = false;
    String formatDate = DateFormat('ddMMyyHHmmss').format(DateTime.now());

    if (modNum[0] == '1') {
      cost = '\$4';
      level = '1000';
    } else if (modNum[0] == '2') {
      cost = '\$5';
      level = '2000';
    } else {
      cost = '\$6';
      if (modNum[0] == '3') {
        level = '3000';
      } else if (modNum[0] == '4') {
        level = '4000';
      } else if (modNum[0] == '5') {
        level = '5000';
      } else if (modNum[0] == '6') {
        level = '6000';
      }
    }
    void uploadQuery() async {
      isUploading = true;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('query_images ')
          .child('$formatDate.jpg');

      await storageRef.putFile(widget.image);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('user queries').add({
        'mentee': user!.email,
        'uid': user!.uid,
        'image_url': imageUrl,
        'query': widget.query,
        'module Code': widget.modcode,
        'cost': cost,
        'level': level,
        'location': widget.location,
        'landmark': widget.landmark,
        'uploadedTime': DateTime.now(),
        'lifetime': DateTime.now(),
      });

      isUploading = false;
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: buildFileImage(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                label: Text(widget.query, style: Theme.of(context).primaryTextTheme.bodySmall,),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Module Code: ${widget.modcode}', style: Theme.of(context).primaryTextTheme.bodySmall,),
                Text('Cost: $cost', style: Theme.of(context).primaryTextTheme.bodySmall,),
                Text('Level: $level', style: Theme.of(context).primaryTextTheme.bodySmall,),
              ],
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                label: Text(widget.location, style: Theme.of(context).primaryTextTheme.bodySmall,),
              ),
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                label: Text(widget.landmark, style: Theme.of(context).primaryTextTheme.bodySmall,),
              ),
            ),
            if (isUploading) const CircularProgressIndicator(),
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
