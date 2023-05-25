import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ta_anywhere/screens/camera.dart';

import 'package:ta_anywhere/screens/set_location.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.image});

  final XFile image;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late File _selectedImage = File(widget.image.path);

  void selectlocation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SetLocationScreen(),
      ),
    );
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        _selectedImage = File(croppedImage.path);
      });
    }
  }

  Widget buildFileImage() => Image.file(_selectedImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Upload Query'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Theme.of(context).colorScheme.primary),
                  ),
                  width: 200,
                  height: 200,
                  child: buildFileImage(),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 30, 97, 33)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CameraScreen(),
                          ),
                        );
                      },
                      child: const Text('Retake'),
                    ),
                    const Padding(padding: EdgeInsets.all(40)),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile == null) return;

                        _cropImage(pickedFile.path);
                      },
                      child: const Text('Browse'),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'What is your query?',
                hintText: 'Describe your situation...',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 30,
                      ),
                      labelText: 'Search Modules',
                      hintText: 'Module Code',
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.white),
                      labelStyle: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                const Text('  ......................  '),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  width: 100,
                  height: 55,
                  child: const Center(child: Text('Code')),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  selectlocation(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Set Location'),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 1, 104, 107),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 30),
                ),
              ),
              onPressed: () {},
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
