import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class QueryInfoScreen extends StatefulWidget {
  const QueryInfoScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<QueryInfoScreen> createState() => _QueryInfoScreenState();
}

class _QueryInfoScreenState extends State<QueryInfoScreen> {
  _uploadtimeconversion(Map<String, dynamic> data) {
    Timestamp uploadtime = data['uploadedTime'];
    final DateTime dateConvert =
        DateTime.fromMillisecondsSinceEpoch(uploadtime.seconds * 1000);
    DateTime now = DateTime.now();
    var diff = now.difference(dateConvert);
    var posted = diff.inMinutes;

    return posted;
  }

  @override
  Widget build(BuildContext context) {
    var posted = _uploadtimeconversion(widget.data);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showImageViewer(
                  context,
                  Image.network(widget.data['image_url']).image,
                  swipeDismissible: true,
                  doubleTapZoomable: true,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                ),
                width: double.infinity,
                height: 300,
                child: Image.network(
                  widget.data['image_url'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.data['query'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text('Module Code: ${widget.data['module Code']}'),
                    Text('Mentee: ${widget.data['mentee']}'),
                    Text('Cost: ${widget.data['cost']}'),
                    Text('Level: ${widget.data['level']}'),
                  ],
                ),
                Column(
                  children: [
                    Text('Posted: $posted min ago'),
                    SizedBox(
                      child: Column(
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.location_on_rounded),
                            label: Text(widget.data['location']),
                            onPressed: () {},
                          ),
                          Text(widget.data['landmark']),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const SearchMentorScreen(),
                //   ),
                // );
              },
              icon: const Icon(Icons.assignment_turned_in_rounded),
              label: const Text('Accept to help?'),
            ),
          ],
        ),
      ),
    );
  }
}
