import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/widget/countdown.dart';

class QueryInfoScreen extends StatefulWidget {
  const QueryInfoScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<QueryInfoScreen> createState() => _QueryInfoScreenState();
}

class _QueryInfoScreenState extends State<QueryInfoScreen> {
  final User? user = Auth().currentUser;
  _lifetimeconversion(Map<String, dynamic> data) {
    Timestamp firstuploadtime = data['lifetime'];
    final DateTime dateConvert =
        DateTime.fromMillisecondsSinceEpoch(firstuploadtime.seconds * 1000);
    DateTime now = DateTime.now();
    var diff = now.difference(dateConvert);
    var lifetime = diff.inMinutes;

    return lifetime;
  }

  String get locationImage {
    final lat = widget.data['y'];
    final lng = widget.data['x'];
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=17&size=600x300&maptype=roadmap&markers=color:red%7C$lat,$lng&key=AIzaSyC7EFshsiUoJdt-lItecOX5Wpm4mGo2dCo';
  }

  void _previewMap() {
    Widget previewContent = Column(
      children: [
        CachedNetworkImage(
          imageUrl: locationImage,
          fit: BoxFit.cover,
          height: 180,
          progressIndicatorBuilder: (context, url, progress) =>
              const CircularProgressIndicator(
                  color: Color.fromARGB(255, 48, 97, 104)),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              widget.data['mentee'],
              style: Theme.of(context).primaryTextTheme.bodyLarge,
            ),
          ),
          content: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                previewContent,
                Text(
                  widget.data['location'],
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget mediumLabel(String data) {
    return Text(
      data,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
    );
  }

  Widget smallLabel(String data) {
    return Text(
      data,
      style: Theme.of(context).primaryTextTheme.bodySmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    var posted = _lifetimeconversion(widget.data);
    String token = widget.data['token'];
    String title = 'Congrats, ${widget.data['mentee']}!';
    String body = 'Mentor found! ${user!.email} is on the way now.';

    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              showImageViewer(
                context,
                CachedNetworkImageProvider(widget.data['image_url']),
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
              child: CachedNetworkImage(
                imageUrl: widget.data['image_url'].toString(),
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(
                        color: Color.fromARGB(255, 48, 97, 104)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 50,
              ),
            ),
          ),
          Center(
            child: Text(
              widget.data['query'],
              style: Theme.of(context).primaryTextTheme.bodyLarge,
              maxLines: 3,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.location_on_rounded),
            label: mediumLabel(widget.data['location']),
            onPressed: _previewMap,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              smallLabel('Landmark: '),
              smallLabel(widget.data['landmark']),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  mediumLabel('Module Code: '),
                  mediumLabel('Mentee: '),
                  mediumLabel('Cost: '),
                  mediumLabel('Level: '),
                  mediumLabel('Posted: '),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mediumLabel(widget.data['module Code']),
                  mediumLabel(widget.data['mentee']),
                  mediumLabel(widget.data['cost']),
                  mediumLabel(widget.data['level']),
                  mediumLabel('$posted min ago'),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          ElevatedButton.icon(
            onPressed: () {
              sendPushMessage(token, title, body);
              FirebaseFirestore.instance
                  .collection('user queries')
                  .doc('${widget.data['menteeid']}')
                  .update({'mentorID': user!.uid})
                  .then((value) => debugPrint('Added MentorID'))
                  .catchError(
                      (error) => debugPrint('Failed to add new data: $error'));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => Countdown(
                    time: 10,
                    data: widget.data,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.assignment_turned_in_rounded),
            label: const Text('Accept to help?'),
          ),
        ],
      ),
    );
  }
}
