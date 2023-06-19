import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ta_anywhere/components/auth.dart';

class QRcode extends StatelessWidget {
  const QRcode({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    String userid = user!.email!;

    return Scaffold(
      appBar: AppBar(
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
          child: QrImageView(
            data: userid,
            version: QrVersions.auto,
            backgroundColor: Colors.white,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color.fromARGB(255, 48, 97, 104),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Color.fromARGB(255, 128, 222, 234),
            ),
            embeddedImage: AssetImage("assets/icons/logo.png"),
            embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(150, 150)),
            size: 400,
          ),
        ),
      ),
      // SizedBox(
      //   height: 20,
      // ),
      // Visibility(
      //   visible: menteeID.isNotEmpty ? true : false,
      //   child: TextButton(
      //     onPressed: () {
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: ((context) => QRScan())));
      //     },
      //     child: Text('Open Scanner'),
      //   ),
      // ),
      // SizedBox(
      //   height: 20,
      // ),
    );
  }
}
