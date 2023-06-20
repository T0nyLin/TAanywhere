import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ta_anywhere/widget/countdown.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key, required this.menteeID, required this.token});

  final String menteeID;
  final String token;

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  final users = FirebaseFirestore.instance.collection('users');
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
  Widget build(BuildContext context) => SafeArea(
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
      ));

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Text(
          barcode != null ? verifyMentee(context).toString() : 'Scan Mentee',
          maxLines: 1,
          style: Theme.of(context).primaryTextTheme.bodySmall,
        ),
      );

  Widget verifyMentee(BuildContext context) {
    if (barcode!.code == widget.menteeID) {
      return FutureBuilder(
        future: users.doc('${widget.menteeID}').get(),
        builder: ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong...');
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text('Mentee not found.');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                Text(
                  "Mentee verified: ${data['username']}",
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => Countdown(
                            time: 60,
                            data: blank,
                            token: widget.token,
                          ),
                        ),
                      );
                    },
                    child: Text('Next')),
              ],
            );
          }

          return CircularProgressIndicator(
            color: Color.fromARGB(255, 48, 97, 104),
          );
        }),
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
