import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/screens/browse.dart';
import 'package:ta_anywhere/widget/qr_code.dart';

class MentorFound extends StatelessWidget {
  const MentorFound({super.key, required this.mentorID});

  final String mentorID;

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;

    final mentor = FirebaseFirestore.instance.collection('users').doc(mentorID).get();

    DateTime timenow = DateTime.now();

    void reupload() async {
      await FirebaseFirestore.instance
          .collection('user queries')
          .doc(user!.uid)
          .update({
        'uploadedTime': timenow,
        'lifetime': timenow,
      });
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

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/icons/profile_pic.png"),
              radius: 60,
            ),
            mediumLabel(
                '$mentorID has accepted to mentor you. He/She will be arriving your location in 10 minutes.'),
            smallLabel(
                '(Else the meet will be cancelled and the query will be reuploaded.)'),
            Transform.rotate(
                angle: 90 * pi / 180,
                child: LoadingAnimationWidget.prograssiveDots(
                    color: Color.fromARGB(255, 48, 97, 104), size: 50)),
            mediumLabel(
                'Do not change your location and make sure to help them locate you.'),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => QRcode())));
                },
                icon: Icon(Icons.qr_code_rounded),
                label: Text('Ready QR')),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Are you sure you want to cancel meet?'),
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                            MaterialButton(
                              onPressed: () {
                                reupload();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const BrowseScreen(),
                                  ),
                                  ModalRoute.withName('/'),
                                );
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        ));
              },
              child: Text('Cancel Meet'),
            ),
          ],
        ),
      ),
    );
  }
}
