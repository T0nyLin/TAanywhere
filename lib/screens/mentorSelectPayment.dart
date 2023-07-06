import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ta_anywhere/components/auth.dart';

import 'package:ta_anywhere/components/sendPushMessage.dart';
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
  Widget mediumLabel(String data) {
    return Text(
      data,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
    );
  }

  Widget getUser(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userRef.doc(user!.uid).get(),
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
          return ElevatedButton.icon(
            onPressed: () {
              sendPushMessage(
                  widget.data['token'],
                  'Well Done! Session over! ${data['username']} has chosen: $currentOption.',
                  user!.uid.toString());
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
              Text(
                'Choose what you would like to receive',
                style: Theme.of(context).primaryTextTheme.bodyLarge,
              ),
              SizedBox(
                height: 50,
              ),
              RadioListTile(
                title: Text(
                  'Receive Payment of ${widget.data['cost']}',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                value: options[0],
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text(
                  'Free of Charge',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
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
