import 'package:flutter/material.dart';
import 'dart:io';

class ConfirmUploadScreen extends StatelessWidget {
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

  Widget buildFileImage() => Image.file(image);

  @override
  Widget build(BuildContext context) {
    String modNum = modcode.toString().replaceAll(RegExp(r"\D"), '');
    String cost = '';
    String level = '';

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
    } else {
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
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.domain_verification_sharp),
              label: const Text('Confirm Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
