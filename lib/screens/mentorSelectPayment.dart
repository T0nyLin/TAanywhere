import 'package:flutter/material.dart';

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
              ElevatedButton.icon(
                  onPressed: () {
                    sendPushMessage(
                        widget.data['token'],
                        'Well Done! Session over! ${widget.data['mentorinfo'][1]} has chosen: $currentOption.',
                        widget.data['mentorID'].toString());
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TabsScreen()),
                      (route) => false,
                    );
                  },
                  icon: Icon(Icons.check_box),
                  label: Text(
                    'Done',
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
