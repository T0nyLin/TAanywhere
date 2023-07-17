import 'package:flutter/material.dart';
import 'package:ta_anywhere/components/textSize.dart';

class FAQscreen extends StatefulWidget {
  const FAQscreen({super.key});

  @override
  State<FAQscreen> createState() => _FAQscreenState();
}

class _FAQscreenState extends State<FAQscreen> {
  Widget expandtile(String question, String ans) {
    return ExpansionTile(
      title: mediumLabel(question, context),
      iconColor: Color.fromARGB(255, 48, 97, 104),
      collapsedIconColor: Color.fromARGB(255, 48, 97, 104),
      children: [
        ListTile(
          title: smallLabel(ans, context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: largeLabel('FAQ', context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            expandtile('1. What is the purpose of the app?',
                'This app is developed to help students get help on their school work instantly from others near them.'),
            expandtile('2. How do I get started?',
                'Just open up the Camera in Tab and start by taking picture of a question and upload it to the platform. Make sure to add a location and describe it accurately, so that the person accepting to help you, can find you easily.'),
            expandtile(
                '3. What happens if I did not reach the mentee within 10 minutes?',
                'Your meet will be cancelled and the mentee can decide if he/she still needs help and wants to re-upload the query or remove it from the platform.'),
            expandtile('4. Must I stay for the whole 60 minute duration?',
                'When you accept to help someone, you are booked for 60 minutes by default. Only when mentee is satisfied that their issue is resolved, then mentee can allow you to end the session earlier.'),
            expandtile(
                '5. What happens if I accidentally terminated the app or the app crashes during the 60 minute session?',
                "1) Ask your mentee to go to Profile Screen.\n2) Tap on the query to expand.\n3) Click on the 'Reset' button at the bottom of the screen to re-upload the query to Browse Screen again.\n\nThis will cancel the previous session so that you can re-accept the query in order to complete the entire meet-session successfully."),
            expandtile('6. How do I increase my ranking?',
                'The more mentees you mentored, the more rank you will gain.\n\nWhen you meet up with the mentee, make sure that the mentee gives you a rating at the end of the session. Otherwise, the session is not recorded and the platform cannot recognise that you have mentored someone successfully.'),
            ExpansionTile(
              title:
                  mediumLabel('7. What are the different rankings?', context),
              iconColor: Color.fromARGB(255, 48, 97, 104),
              collapsedIconColor: Color.fromARGB(255, 48, 97, 104),
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          mediumLabel('Rank', context),
                          smallLabel('Newcomer', context),
                          smallLabel('Beginner', context),
                          smallLabel('Average', context),
                          smallLabel('Talented', context),
                          smallLabel('Competent', context),
                          smallLabel('Proficient', context),
                          smallLabel('Master', context),
                          smallLabel('Grand Master', context),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mediumLabel('Mentees mentored', context),
                          smallLabel('0-2', context),
                          smallLabel('3-5', context),
                          smallLabel('6-10', context),
                          smallLabel('11-20', context),
                          smallLabel('21-35', context),
                          smallLabel('36-60', context),
                          smallLabel('61-80', context),
                          smallLabel('>80', context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
