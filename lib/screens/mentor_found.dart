import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/reupload_del.dart';
import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/components/textSize.dart';
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
    String? _profilePicUrl;

    void cancelAlert(Map<String, dynamic> data) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: largeLabel(
                    'Are you sure you want to cancel meet?', context),
                content:
                    smallLabel('Note: your query will be reuploaded.', context),
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
            return mediumLabel('Something went wrong', context);
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return mediumLabel('Mentor does not exist', context);
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
            _profilePicUrl = data2['profile_pic'];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_profilePicUrl != null && data2['displayPic'] == true) {
                      showImageViewer(context,
                          CachedNetworkImageProvider(_profilePicUrl.toString()),
                          swipeDismissible: true, doubleTapZoomable: true);
                    }
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/icons/profile_pic.png'),
                    foregroundImage: _profilePicUrl != null &&
                            data2['displayPic'] == true
                        ? CachedNetworkImageProvider(_profilePicUrl.toString())
                            as ImageProvider<Object>
                        : AssetImage('assets/icons/profile_pic.png'),
                  ),
                ),
                Center(
                  child: mediumLabel(
                      '$mentorName has accepted to mentor you. $gender will be arriving your location in 10 minutes.',
                      context),
                ),
                smallLabel(
                    '(Else the meet will be cancelled and the query can be reuploaded.)',
                    context),
                Transform.rotate(
                    angle: -90 * pi / 180,
                    child: LoadingAnimationWidget.prograssiveDots(
                        color: Color.fromARGB(255, 48, 97, 104), size: 50)),
                mediumLabel(
                    'Do not change your location and make sure to help them locate you.',
                    context),
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
                    label: mediumLabel('Return Home', context)),
                SizedBox(
                  height: 60,
                ),
                TextButton(
                  onPressed: () {
                    cancelAlert(data);
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text('Meet cancelled'),
                      ));
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
          return mediumLabel('Something went wrong', context);
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return mediumLabel('Query does not exist', context);
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
