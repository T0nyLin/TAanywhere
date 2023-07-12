import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/reupload_del.dart';
import 'package:ta_anywhere/widget/tabs.dart';

class PaymentAndRateScreen extends StatefulWidget {
  const PaymentAndRateScreen({super.key, required this.body});

  final String body;

  @override
  State<PaymentAndRateScreen> createState() => _PaymentAndRateScreenState();
}

List<String> options = ['Receive Payment'];

class _PaymentAndRateScreenState extends State<PaymentAndRateScreen> {
  String mentorID = '';
  int rater = 0;
  double rating = 0;
  double newrating = 0;
  final User? user = Auth().currentUser;
  String image_url = '';

  Widget mediumLabel(String data) {
    return Text(
      data,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
    );
  }

  Widget getQuery(BuildContext context) {
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
          image_url = data['image_url'];
          return getUser(context, mentorID);
        }
        return Container();
      },
    );
  }

  Widget getUser(BuildContext context, String mentorID) {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');
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
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          rater = data['rater'] + 1;
          newrating = data['rating'] + rating;
          return Container();
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                  allowHalfRating: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4),
                  itemSize: 46,
                  minRating: 0,
                  itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                  updateOnDrag: true,
                  onRatingUpdate: (rating) => setState(() {
                        this.rating = rating;
                      })),
              Text(
                'Rate your mentor: $rating',
                style: Theme.of(context).primaryTextTheme.bodyLarge,
              ),
              getQuery(context),
              if (widget.body.contains('Free'))
                ElevatedButton.icon(
                    onPressed: () {
                      updateRating(mentorID, rater, newrating);
                      deleteQuery(user!.uid);
                      deleteImages(image_url);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => TabsScreen()),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.home_rounded),
                    label: Text('Submit')),
              if (widget.body.contains('Payment'))
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Please pay your mentor via PayLah! or other payment applications. Thank You.',
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          updateRating(mentorID, rater, newrating);
                          deleteQuery(user!.uid);
                          deleteImages(image_url);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => TabsScreen()),
                            (route) => false,
                          );
                          await LaunchApp.openApp(
                            androidPackageName: 'com.dbs.dbspaylah',
                            openStore: false,
                            appStoreLink:
                                'https://apps.apple.com/sg/app/dbs-paylah/id878528688',
                          );
                        },
                        icon: Icon(Icons.home_rounded),
                        label: Text('Submit &\nOpen App')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
