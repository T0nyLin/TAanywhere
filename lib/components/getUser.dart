import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget getUser(BuildContext context, String mentorID) {
  CollectionReference mentor = FirebaseFirestore.instance.collection('users');
  String gender = '';

  return FutureBuilder<DocumentSnapshot>(
    future: mentor.doc(mentorID).get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return Text("Mentor does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        if (data['gender'] == 'Male') {
          gender = 'He';
        } else {
          gender = 'She';
        }
        return Text(
          '${data['username']} has accepted to mentor you. $gender will be arriving your location in 10 minutes.',
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        );
      }

      return Text("loading");
    },
  );
}
