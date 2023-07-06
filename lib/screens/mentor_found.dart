import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/screens/browse.dart';
import 'package:ta_anywhere/widget/countdown.dart';
import 'package:ta_anywhere/widget/qr_code.dart';
import 'package:ta_anywhere/widget/tabs.dart';

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

    Widget getUser(BuildContext context, String menteeID, String mentorID) {
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
            return mediumLabel(
                '$mentorName has accepted to mentor you. $gender will be arriving your location in 10 minutes.');
          }

          return CircularProgressIndicator(
            color: Color.fromARGB(255, 48, 97, 104),
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
          print(mentorID);
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              body: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/icons/profile_pic.png"),
                      radius: 60,
                    ),
                    Center(
                        child: getUser(
                      context,
                      user.uid,
                      mentorID,
                    )),
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
                        TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => TabsScreen())));
                            },
                            icon: Icon(Icons.home_rounded),
                            label: mediumLabel('Return Home')),
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => QRcode())));
                            },
                            icon: Icon(Icons.qr_code_rounded),
                            label: Text('Ready QR')),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
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
                                        sendPushMessage(
                                            data['mentorToken'],
                                            'Sorry, $mentorName.',
                                            '${data['mentee']} has chosen to cancel the meet. Sorry for the inconvenience.');
                                        reupload(user.uid);
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
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
