import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ta_anywhere/screens/confirmUpload.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:ta_anywhere/components/place_service.dart';
import 'package:ta_anywhere/widget/set_location.dart';
import 'package:ta_anywhere/components/modulecode.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.image});

  final XFile image;
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late File _selectedImage = File(widget.image.path);
  final _formKey = GlobalKey<FormState>();
  var _queryInput = '';
  final _modController = TextEditingController();
  final _destinationController = TextEditingController();
  var _landmarkInput = '';

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
  void dispose() {
    _destinationController.dispose();
    _modController.dispose();
    super.dispose();
  }

  void _search(BuildContext context) async {
    final sessionToken = const Uuid().v4();
    final Suggestion? result = await showSearch(
      context: context,
      delegate: SetLocation(sessionToken),
    );
    if (result != null) {
      setState(() {
        _destinationController.text = result.description;
      });
    }
  }

  void _saveQuery(BuildContext context) {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfirmUploadScreen(
          image: _selectedImage,
          query: _queryInput,
          modcode: _modController.text.toString(),
          location: _destinationController.text,
          landmark: _landmarkInput,
        ),
      ),
    );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Query'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      width: 200,
                      height: 200,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: buildFileImage(),
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 30, 97, 33)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Retake'),
                        ),
                        const Padding(padding: EdgeInsets.all(40)),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile == null) return;

                            _cropImage(pickedFile.path);
                          },
                          child: const Text('Browse'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  maxLength: 280,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What is your query?',
                    hintText: 'Describe your situation...',
                    counterText: "",
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
                    _queryInput = value!;
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
                            labelText: 'Search Modules',
                            hintText: 'Module Code',
                            hintStyle: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                            labelStyle: const TextStyle(fontSize: 9),
                            counterText: "",
                          ),
                        ),
                        suggestionsCallback: getModCodes,
                        itemBuilder: (context, ModuleCode? suggestion) {
                          final modcode = suggestion!;
                          return ListTile(
                            title: Text(modcode.modCode),
                          );
                        },
                        noItemsFoundBuilder: (context) => const Center(
                          child: Text(
                            'Module not found.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
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
                              value.trim().length > 10) {
                            return 'Invalid Code';
                          }
                          return null;
                        },
                      ),
                    ),
                    // const Text('  ......................  '),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       width: 1,
                    //       color: Colors.black,
                    //     ),
                    //     borderRadius: BorderRadius.circular(13),
                    //   ),
                    //   width: 100,
                    //   height: 55,
                    //   child: Center(
                    //     child: Center(
                    //       child: Text(_modController.text),
                    //     ),
                    //   ),
                    // ),
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
                    readOnly: true,
                    onTap: () {
                      _search(context);
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
                      hintText: "Set Location",
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
                      hintMaxLines: 2,
                      labelStyle: const TextStyle(fontSize: 10),
                      counterText: "",
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
                      _landmarkInput = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 1, 104, 107),
                    ),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 30),
                    ),
                  ),
                  onPressed: () {
                    _saveQuery(context);
                  },
                  icon: const Icon(Icons.arrow_circle_right_outlined),
                  label: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
