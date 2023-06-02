import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ta_anywhere/components/auth.dart';

class ConfirmUploadScreen extends StatelessWidget {
  ConfirmUploadScreen({
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
  String cost = '';
  String level = '';

  final User? user = Auth().currentUser!;
  bool isUploading = false;

  Widget buildFileImage() => Image.file(image);

  void uploadQuery() async {
    isUploading = true;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('query_images ')
        .child('${user!.uid}.jpg');

    await storageRef.putFile(image);
    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('user queries')
        .add({
      'mentee': user!.email,
      'image_url': imageUrl,
      'query': query,
      'module Code': modcode,
      'cost': cost,
      'level': level,
      'location': location,
      'landmark': landmark,
      'uploadedTime': Timestamp.now(),
    });

    isUploading = false;
  }

  @override
  Widget build(BuildContext context) {
    String modNum = modcode
        .toString()
        .replaceAll(RegExp(r"\D"), ''); //remove letters from module code

    if (modNum[0] == '1') {
      cost = '\$4';
      level = '1000';
    } else if (modNum[0] == '2') {
      cost = '\$5';
      level = '2000';
    } else if (modNum[0] == '3') {
      cost = '\$6';
      level = '3000';
    } else if (modNum[0] == '4') {
      cost = '\$7';
      level = '4000';
    } else if (modNum[0] == '5') {
      cost = '\$8';
      level = '5000';
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
                label: Text(query),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Module Code: $modcode'),
                Text('Cost: $cost'),
                Text('Level: $level'),
              ],
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                label: Text(location),
              ),
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                label: Text(landmark),
              ),
            ),
            if (isUploading) const CircularProgressIndicator(),
            if (!isUploading)
              ElevatedButton.icon(
                onPressed: uploadQuery,
                icon: const Icon(Icons.domain_verification_sharp),
                label: const Text('Confirm Upload'),
              ),
          ],
        ),
      ),
    );
  }
}
