import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:ta_anywhere/widget/tabs.dart';

class PaymentAndRateScreen extends StatefulWidget {
  const PaymentAndRateScreen(
      {super.key, required this.mentorID, required this.title});

  final String title;
  final String mentorID;

  @override
  State<PaymentAndRateScreen> createState() => _PaymentAndRateScreenState();
}

List<String> options = ['Receive Payment'];

class _PaymentAndRateScreenState extends State<PaymentAndRateScreen> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(),
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
              if (widget.title.contains('Free'))
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => TabsScreen()),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.home_rounded),
                    label: Text('Submit')),
              if (widget.title.contains('Payment'))
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please pay your mentor via PayLah! or other payment applications. Thank You.',
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => TabsScreen()),
                            (route) => false,
                          );
                          if (Platform.isIOS)
                            await LaunchApp.openApp(
                              appStoreLink:
                                  'https://apps.apple.com/sg/app/dbs-paylah/id878528688',
                              iosUrlScheme: 'dbspaylah://',
                            );
                          if (Platform.isAndroid)
                            await LaunchApp.openApp(
                              androidPackageName: 'com.dbs.dbspaylah',
                              openStore: false,
                            );
                        },
                        icon: Icon(Icons.home_rounded),
                        label: Text('Open App')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
