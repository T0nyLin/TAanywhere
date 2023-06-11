import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:math';

import 'package:ta_anywhere/screens/upload.dart';

List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool flash = false;
  bool isCameraFront = true;
  double transform = 0;
  XFile? imageFile;

  void getImage(BuildContext context) async {
    final XFile? pickedfile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedfile == null) return;
    _cropImage(pickedfile.path);
  }

  void takePhoto(BuildContext context) async {
    await cameraValue;

    XFile image = await _cameraController.takePicture();
    _cropImage(image.path);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      imageFile = XFile(croppedImage.path);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadScreen(
            image: imageFile!,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 48, 97, 104),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 0.0,
            height: 100,
            child: Container(
              color: const Color.fromARGB(86, 0, 0, 0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              isCameraFront = !isCameraFront;
                              transform = transform + pi;
                            });
                            int cameraPos = isCameraFront ? 0 : 1;
                            _cameraController = CameraController(
                                cameras![cameraPos], ResolutionPreset.high);
                            cameraValue = _cameraController.initialize();
                          },
                          icon: Transform.rotate(
                            angle: transform,
                            child: const Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: const Color.fromARGB(86, 0, 0, 0),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            flash = !flash;
                          });
                          flash
                              ? _cameraController.setFlashMode(FlashMode.torch)
                              : _cameraController.setFlashMode(FlashMode.off);
                        },
                        icon: Icon(
                          flash
                              ? Icons.flash_on_outlined
                              : Icons.flash_off_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          takePhoto(context);
                        },
                        child: const Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          getImage(context);
                        },
                        icon: const Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
