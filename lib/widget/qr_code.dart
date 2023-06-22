import 'dart:async';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ta_anywhere/components/auth.dart';

class QRcode extends StatelessWidget {
  const QRcode({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    String userid = user!.uid;

    Future<ui.Image> _loadImage() async {
      final completer = Completer<ui.Image>();
      final data = await rootBundle.load("assets/icons/logo.png");
      ui.decodeImageFromList(data.buffer.asUint8List(), completer.complete);

      return completer.future;
    }

    final qrCode = FutureBuilder(
      future: _loadImage(),
      builder: (ctx, snapshot) {
        final size = 400.0;
        if (!snapshot.hasData) {
          return Container(
            color: Colors.black,
            height: size,
            width: size,
          );
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            // data: '1234',
            data: userid,
            version: QrVersions.auto,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color.fromARGB(255, 48, 97, 104),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
              // color: Color.fromARGB(255, 128, 222, 234),
            ),
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            embeddedImage: snapshot.data,
            embeddedImageStyle:
                QrEmbeddedImageStyle(size: const Size.square(50)),
          ),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'MY QR',
          style: Theme.of(context)
              .primaryTextTheme
              .bodyLarge!
              .copyWith(fontSize: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: qrCode),
        ),
      ),
    );
  }
}
