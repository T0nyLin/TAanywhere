import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/reupload_del.dart';
import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/widget/qr_code.dart';
import 'package:ta_anywhere/widget/tabs.dart';
import 'package:ta_anywhere/widget/viewprofile.dart';

class MentorFound extends StatelessWidget {
  const MentorFound({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    String mentorID = '';
    String mentorName = '';

    Widget mediumLabel(String data) {
      return Text(
        data,
        style: Theme.of(context).primaryTextTheme.bodyMedium,
        textAlign: TextAlign.center,
      );
    }

    Widget smallLabel(String data) {
      return Text(
        data,
        style: Theme.of(context).primaryTextTheme.bodySmall,
        textAlign: TextAlign.center,
      );
    }

    void cancelAlert(Map<String, dynamic> data) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: mediumLabel('Are you sure you want to cancel meet?'),
                content: smallLabel('Note: your query will be reuploaded.'),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      reupload(user!.uid);
                      sendPushMessage(
                          data['mentorToken'],
                          'Sorry, $mentorName.',
                          '${data['mentee']} has chosen to cancel the meet. Apologies for the inconvenience.');
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => TabsScreen()),
                        (route) => false,
                      );
                    },
                    child: Text('Yes'),
                  ),
                ],
              ));
    }

    Widget getUser(BuildContext context, String menteeID, String mentorID,
        Map<String, dynamic> data) {
      CollectionReference userRef =
          FirebaseFirestore.instance.collection('users');
      String gender = '';
      return FutureBuilder<DocumentSnapshot>(
        future: userRef.doc(mentorID).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return mediumLabel('Something went wrong');
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return mediumLabel('Mentor does not exist');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data2 =
                snapshot.data!.data() as Map<String, dynamic>;
            if (data2['gender'] == 'Male') {
              gender = 'He';
            } else if (data2['gender'] == 'Female') {
              gender = 'She';
            } else {
              gender = 'They';
            }
            mentorName = data2['username'];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/icons/profile_pic.png"),
                  radius: 60,
                ),
                Center(
                  child: mediumLabel(
                      '$mentorName has accepted to mentor you. $gender will be arriving your location in 10 minutes.'),
                ),
                smallLabel(
                    '(Else the meet will be cancelled and the query can be reuploaded.)'),
                Transform.rotate(
                    angle: -90 * pi / 180,
                    child: LoadingAnimationWidget.prograssiveDots(
                        color: Color.fromARGB(255, 48, 97, 104), size: 50)),
                mediumLabel(
                    'Do not change your location and make sure to help them locate you.'),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => ViewUserProfileScreen(
                                    userid: data['mentorid'],
                                    username: mentorName,
                                  ))));
                        },
                        icon: Icon(Icons.person),
                        label: Text("View $mentorName's Profile")),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => QRcode())));
                        },
                        icon: Icon(Icons.qr_code_rounded),
                        label: Text('Ready QR')),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => TabsScreen())));
                    },
                    icon: Icon(Icons.home_rounded),
                    label: mediumLabel('Return Home')),
                SizedBox(
                  height: 60,
                ),
                TextButton(
                  onPressed: () {
                    cancelAlert(data);
                  },
                  child: Text('Cancel Meet'),
                ),
              ],
            );
          }

          return Center(
            child: LoadingAnimationWidget.waveDots(
                color: const Color.fromARGB(255, 48, 97, 104), size: 60),
          );
        },
      );
    }

    CollectionReference mentorRef =
        FirebaseFirestore.instance.collection('user queries');
    return FutureBuilder<DocumentSnapshot>(
      future: mentorRef.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return mediumLabel('Something went wrong');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return mediumLabel('Query does not exist');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          mentorID = data['mentorid'];
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              body: Container(
                padding: EdgeInsets.all(8.0),
                child: getUser(
                  context,
                  user.uid,
                  mentorID,
                  data,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: LoadingAnimationWidget.waveDots(
                color: const Color.fromARGB(255, 48, 97, 104), size: 60),
          ),
        );
      },
    );
  }
}
