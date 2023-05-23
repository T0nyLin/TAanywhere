import 'dart:io';
import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Upload Query'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width:MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height,
               child: Image.file(File(imagePath)),
            )
          ],
        ),
      )
    );
  }
}
