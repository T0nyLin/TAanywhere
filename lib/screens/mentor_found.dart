import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/widget/qr_code.dart';

class MentorFound extends StatelessWidget {
  const MentorFound({super.key, required this.mentorName});

  final String mentorName;

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;

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

    return Container(
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
              '$mentorName has accepted to mentor you. He/She will be arriving your location in 10 minutes.'),
          smallLabel(
              '(Else the meet will be cancelled and the query will be reuploaded.)'),
          mediumLabel(
              'Do not change your location and make sure to help them locate you.'),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) =>
                      QRcode())));
              },
              icon: Icon(Icons.qr_code_rounded),
              label: Text('Ready QR')),
          TextButton(
            onPressed: reupload,
            child: Text('Cancel Meet'),
          ),
        ],
      ),
    );
  }
}
