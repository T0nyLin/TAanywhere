import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ta_anywhere/components/auth.dart';

import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/components/textSize.dart';
import 'package:ta_anywhere/widget/tabs.dart';

class MentorSelectReceiveModeScreen extends StatefulWidget {
  const MentorSelectReceiveModeScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<MentorSelectReceiveModeScreen> createState() =>
      _MentorSelectReceiveModeScreenState();
}

List<String> options = ['Receive Payment', 'Free of Charge'];

class _MentorSelectReceiveModeScreenState
    extends State<MentorSelectReceiveModeScreen> {
  String currentOption = options[0];
  final User? user = Auth().currentUser;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  Widget getUser(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userRef.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return mediumLabel('Something went wrong', context);
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return mediumLabel('Mentor does not exist', context);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ElevatedButton.icon(
            onPressed: () {
              sendPushMessage(widget.data['token'], 'Well Done! Session over!',
                  '${data['username']} has chosen: $currentOption.');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => TabsScreen()),
                (route) => false,
              );
            },
            icon: Icon(Icons.check_box),
            label: Text(
              'Done',
            ),
          );
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
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              largeLabel('Choose what you would like to receive', context),
              SizedBox(
                height: 50,
              ),
              RadioListTile(
                title: mediumLabel('Receive Payment of ${widget.data['cost']}', context),
                value: options[0],
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: mediumLabel('Free of Charge', context),
                value: options[1],
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                },
              ),
              getUser(context),
            ],
          ),
        ),
      ),
    );
  }
}
