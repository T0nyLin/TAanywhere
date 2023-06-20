import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/screens/browse.dart';
import 'package:ta_anywhere/widget/qr_scanner.dart';

class Countdown extends StatefulWidget {
  const Countdown({
    super.key,
    required this.time,
    required this.data,
    required this.token,
  });

  final Map<String, dynamic> data;
  final int time;
  final String token;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  final User? user = Auth().currentUser;
  DateTime timenow = DateTime.now();
  static Duration countdownDuration = const Duration();
  Duration duration = const Duration();
  Timer? timer;
  bool isCountDown = true;

  void reupload() async {
    await FirebaseFirestore.instance
        .collection('user queries')
        .doc(widget.data['uid'])
        .update({
      'uploadedTime': timenow,
      'lifetime': timenow,
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();

    const minusSeconds = 1;

    reset();
    setState(() {
      final seconds = duration.inSeconds - minusSeconds;
      if (seconds < 0 && widget.time == 10) {
        timer?.cancel();
        sendPushMessage(widget.data['token'], 'Oops!',
            'Your mentor did not reach on time!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BrowseScreen()),
          ModalRoute.withName('/'),
        );
        //add local noti to say timer run out, and meet is cancelled
        reupload();
      } else if (seconds < 0 && widget.time == 60) {
        timer?.cancel();

        //sendPushMessage(widget.data['token'], 'Well Done!', 'Session Over!');
      }
    });
  }

  void reset() {
    if (isCountDown) {
      setState(() {
        countdownDuration = Duration(minutes: widget.time);
        duration = countdownDuration;
      });
    } else {
      setState(() => duration = const Duration());
    }
  }

  void minusTime() {
    const minusSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds - minusSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => minusTime());
  }

  void stopTimer() {
    timer?.cancel();
  }

  void menteeFound() {
    showOverlay(
      duration: const Duration(seconds: 10),
      (context, progress) => AlertDialog(
        title: Center(
          child: Text(
            'Are you with your mentee?',
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              OverlaySupportEntry? dismissButton =
                  OverlaySupportEntry.of(context);
              if (dismissButton != null) {
                dismissButton.dismiss();
              }
            },
            child: const Text('No'),
          ),
          MaterialButton(
            onPressed: () {
              OverlaySupportEntry? dismissButton =
                  OverlaySupportEntry.of(context);
              if (dismissButton != null) {
                dismissButton.dismiss();
              }
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => QRScan(
                        menteeID: widget.data['menteeid'],
                        token: widget.data['token'],
                      ))));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void sessionOver() {
    showOverlay(
      duration: const Duration(seconds: 10),
      (context, progress) => AlertDialog(
        title: Center(
          child: Text(
            'Stop session now?',
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              OverlaySupportEntry? dismissButton =
                  OverlaySupportEntry.of(context);
              if (dismissButton != null) {
                dismissButton.dismiss();
              }
            },
            child: const Text('No'),
          ),
          MaterialButton(
            onPressed: () {
              OverlaySupportEntry? dismissButton =
                  OverlaySupportEntry.of(context);
              if (dismissButton != null) {
                dismissButton.dismiss();
              }
              sendPushMessage(widget.token, 'Session Over', '');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => QRScan(
                        menteeID: widget.data['menteeid'],
                        token: widget.data['token'],
                      ))));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SpinKitPouringHourGlass(color: Color.fromARGB(255, 48, 97, 104)),
        const SizedBox(
          width: 8,
        ),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(
          width: 8,
        ),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 72,
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(header),
      ],
    );
  }

  Widget mediumLabel(String data) {
    return Text(
      data,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = timer == null ? false : timer!.isActive;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTime(),
          const SizedBox(
            height: 80,
          ),
          if (isRunning && widget.time == 10)
            ElevatedButton(
              onPressed: () {
                menteeFound();
              },
              child: const Text('STOP'),
            ),
          const SizedBox(
            height: 40,
          ),
          mediumLabel('See Location on Map:'),
          TextButton.icon(
            icon: const Icon(Icons.location_on_rounded),
            label: mediumLabel(widget.data['location']),
            onPressed: () {},
          ),
          if (isRunning && widget.time == 60)
            ElevatedButton(
              onPressed: () {
                sessionOver();
              },
              child: const Text('STOP'),
            ),
        ],
      )),
    );
  }
}
