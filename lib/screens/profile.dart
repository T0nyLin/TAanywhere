import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/screens/setting.dart';
import 'package:ta_anywhere/widget/qr_code.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text("Log Out"),
    );
  }

  Widget _settingButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: IconButton(
        icon: const Icon(Icons.settings),
        iconSize: 40,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingScreen()),
          );
        },
      ),
    );
  }

  Widget _qrCodeButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: IconButton(
        icon: const Icon(Icons.qr_code),
        iconSize: 40,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) =>
                      QRcode())));
        },
      ),
    );
  }

  Widget _mentorRank() {
    return const Text(
      'Year 2',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _ratingStars(int score) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData starIcon = i < score ? Icons.star : Icons.star_border;
      Widget star = Icon(starIcon, color: Colors.amber);
      stars.add(star);
    }
    return Row(children: stars);
  }

  Widget _moduleBox(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 50,
            left: 30,
            child: Text(
              'Mentor Rank:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 30,
            child: _mentorRank(),
          ),
          Positioned(
            top: 120,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rating:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _ratingStars(2), // Change the score here to test
                ),
              ],
            ),
          ),
          Positioned(
            top: 200,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Modules this Sem:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  children: [
                    _moduleBox("MA2001"),
                    const SizedBox(width: 10),
                    _moduleBox("CS2105"),
                    const SizedBox(width: 10),
                    _moduleBox("CS2106"),
                    const SizedBox(width: 10),
                    _moduleBox("GEC1010"),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  children: [
                    _moduleBox("IS2238"),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Modules I can help with:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  children: [
                    _moduleBox("MA1521"),
                    const SizedBox(width: 10),
                    _moduleBox("CS2040S"),
                    const SizedBox(width: 10),
                    _moduleBox("CS1231S"),
                    const SizedBox(width: 10),
                    _moduleBox("CS2030"),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  children: [
                    _moduleBox("CS2100"),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _settingButton(context),
                    const SizedBox(height: 50),
                    _qrCodeButton(context),
                  ],
                ),
                const SizedBox(width: 20),
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                      'assets/icons/profile_pic.png'), // Replace with user image from database soon
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 30,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _userUid(),
                  _signOutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
