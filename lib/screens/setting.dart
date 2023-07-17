import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ta_anywhere/widget/widget_tree.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/textSize.dart';
import 'package:ta_anywhere/screens/editProfile.dart';
import 'package:ta_anywhere/screens/editPassword.dart';
import 'package:ta_anywhere/screens/faq.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  void _navigateToEditPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: largeLabel('Settings', context),
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
            onTap: () {
              _navigateToEditPassword(context);
            },
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
          ),
          ListTile(
            title: Text("FAQ"),
            leading: Icon(Icons.question_mark_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQscreen()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text("Contact us"),
              leading: Icon(
                Icons.mail,
                color: Color(0xFF585858),
              ),
              iconColor: Color.fromARGB(255, 69, 69, 69),
              trailing: Icon(Icons.arrow_forward_ios),
              children: [
                ListTile(
                  title: mediumLabel('taanywhere@gmail.com', context),
                  onTap: () async {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map((MapEntry<String, String> e) =>
                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&');
                    }

                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'taanywhere@gmail.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': '',
                        'body': '',
                      }),
                    );
                    launchUrl(emailUri);
                    try {
                      await launchUrl(emailUri);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  onLongPress: () {
                    Clipboard.setData(
                            ClipboardData(text: 'taanywhere@gmail.com'))
                        .then((value) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text('Copied to Clipboard'),
                        ));
                    });
                  },
                  subtitle: smallLabel(
                      'Please choose Outlook to send message to us.', context),
                  trailing: Icon(
                    Icons.touch_app,
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: _userUid(),
            subtitle: Text(
              'Log Out',
              style: TextStyle(
                  fontSize: 13, color: const Color.fromARGB(255, 175, 52, 44)),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Log Out'),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () {
                          signOut();
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              content: Text('Logged out successfully'),
                            ));
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WidgetTree()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
