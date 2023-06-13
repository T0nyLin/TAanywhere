import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:ta_anywhere/components/auth.dart';

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

  void sendPushMessage(String token, String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAIik8mAg:APA91bHxWYYQtiqIqpDYr_xQ1qX6CXYwcTjtyxABYFR6XMVoGO9XdWh1cAm9DrSIrJzFBAEAlaYPzhzj3GjeO08o6F15h27XqmDUVz8M3RQFaCrjbJmVpkkpRU1HcakGAshXbPrpiH6j',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'title': title,
              'body': body,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'to': token,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var posted = _lifetimeconversion(widget.data);
    String token = widget.data['token'];
    String title = 'Congrats, ${widget.data['mentee']}!';
    String body = 'Mentor found! ${user!.email} is on the way!';

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
            label: Text(
              widget.data['location'],
              style: Theme.of(context).primaryTextTheme.bodyMedium,
              maxLines: 2,
            ),
            onPressed: _previewMap,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Landmark: ',
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
              Text(
                '${widget.data['landmark']}',
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
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
                  Text(
                    'Module Code: ',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    'Mentee: ',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    'Cost: ',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    'Level: ',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    'Posted: ',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.data['module Code']}',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    '${widget.data['mentee']}',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    '${widget.data['cost']}',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    '${widget.data['level']}',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    '$posted min ago',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
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
            },
            icon: const Icon(Icons.assignment_turned_in_rounded),
            label: const Text('Accept to help?'),
          ),
        ],
      ),
    );
  }
}
