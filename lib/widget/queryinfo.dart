import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/screens/browse.dart';
import 'package:ta_anywhere/screens/editnreupload.dart';
import 'package:ta_anywhere/widget/countdown.dart';
import 'package:ta_anywhere/widget/tabs.dart';

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
    final lat = widget.data['y-coordinate'];
    final lng = widget.data['x-coordinate'];
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

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 165, 228, 234),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.2,
        maxChildSize: 0.3,
        minChildSize: 0.1,
        builder: (context, scrollController) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EditnReUploadScreen(data: widget.data)));
                },
                icon: Icon(Icons.edit),
                label: Text(
                  'Edit',
                  style: Theme.of(context).primaryTextTheme.bodyLarge!,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  deleteQuery(widget.data);
                  deleteImages(widget.data);
                  ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                      content: Text('Query removed successfully'),
                    ));
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => TabsScreen()),
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                ),
                label: Text(
                  'Remove Query',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyLarge!
                      .copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
          controller: scrollController,
        ),
      ),
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

    return Stack(
      children: [
        if (user!.uid == widget.data['menteeid'])
          Positioned(
            top: 10,
            right: 35,
            child: IconButton(
                onPressed: () {
                  _showModalBottomSheet(context);
                },
                icon: Icon(Icons.more_horiz)),
          ),
        Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ),
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
              if (user!.uid != widget.data['menteeid'])
                ElevatedButton.icon(
                  onPressed: () {
                    sendPushMessage(token, title, body);
                    FirebaseFirestore.instance
                        .collection('user queries')
                        .doc('${widget.data['menteeid']}')
                        .update({
                          'mentorID': user!.uid,
                          'inSession': true,
                        })
                        .then((value) => debugPrint('Added MentorID'))
                        .catchError((error) =>
                            debugPrint('Failed to add new data: $error'));
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
        ),
      ],
    );
  }
}
