import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ta_anywhere/components/sendPushMessage.dart';
import 'package:ta_anywhere/widget/countdown.dart';

class QRScan extends StatefulWidget {
  const QRScan({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  final users = FirebaseFirestore.instance.collection('user queries');
  final qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? barcode;
  QRViewController? controller;
  Map<String, dynamic> blank = {};

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false, //disable system back button
        child: SafeArea(
            child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQrView(context),
              Positioned(
                bottom: 10,
                child: buildResult(),
              ),
            ],
          ),
        )),
      );

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Column(
          children: [
            barcode != null
                ? verifyMentee(context)
                : Text(
                    'Scan Mentee',
                    maxLines: 1,
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                  ),
          ],
        ),
      );

  Widget verifyMentee(BuildContext context) {
    if (barcode!.code == widget.data['menteeid']) {
      return Column(
        children: [
          Text(
            "Mentee verified: ${widget.data['mentee']}",
            maxLines: 1,
            style: Theme.of(context)
                .primaryTextTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          TextButton(
              onPressed: () {
                sendPushMessage(widget.data['token'], 'Verified!',
                    'This is to notify that mentor has verified you. Session will begin now.');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => Countdown(
                      time: 60,
                      data: widget.data,
                    ),
                  ),
                );
              },
              child: Text(
                'Next',
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              )),
        ],
      );
    } else {
      return Text('Mentee not found.');
    }
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Color.fromARGB(255, 48, 97, 104),
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }
}
