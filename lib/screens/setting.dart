import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/screens/editProfile.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key});

  final User? user = Auth().currentUser;

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: Text("Edit Profile"),
            leading: Icon(Icons.person_outline_rounded),
            onTap: () {
              _navigateToEditProfile(context);
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("Change Password"),
            leading: Icon(Icons.edit),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: Text(
              "Help and Support",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("FAQ"),
            leading: Icon(Icons.question_mark_rounded),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("Contact us"),
            leading: Icon(Icons.phone_iphone_rounded),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: _userUid(),
          ),
        ],
      ),
    );
  }
}
