import 'package:flutter/material.dart';
import 'package:ta_anywhere/components/textSize.dart';

class FAQscreen extends StatefulWidget {
  const FAQscreen({super.key});

  @override
  State<FAQscreen> createState() => _FAQscreenState();
}

class _FAQscreenState extends State<FAQscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: mediumLabel('1. What is the purpose of the app?', context),
              children: [
                ListTile(
                  title: smallLabel(
                      'This app is developed to help students get help instantly from others near you.',
                      context),
                )
              ],
            ),
            ExpansionTile(
              title: mediumLabel('2. How do I get started?', context),
              children: [
                ListTile(
                  title: smallLabel(
                      'Just open up the Camera in Tab and start taking picture of a question and upload it to the platform. Make sure to add a location and describe it well, so that the person accepting to help you, can find you easily.',
                      context),
                )
              ],
            ),
            ExpansionTile(
              title: mediumLabel(
                  '3. What happens if I did not reach the mentee within 10 minutes?',
                  context),
              children: [
                ListTile(
                  title: smallLabel(
                      'Your meet will be cancelled and the mentee can decide if he/she still needs help and wants to re-upload the query or remove it from the platform.',
                      context),
                )
              ],
            ),
            ExpansionTile(
              title: mediumLabel(
                  '4. Must I stay for the whole 60 minute duration?', context),
              children: [
                ListTile(
                  title: smallLabel(
                      'When you accept to help someone, you are booked for 60 minutes by default. Only when mentee is satisfied that their issue is resolved, then mentee can allow you to end the session earlier.',
                      context),
                )
              ],
            ),
            ExpansionTile(
              title: mediumLabel(
                  '5. What happens if I accidentally terminated the app or the app crashes during the 60 minute session?',
                  context),
              children: [
                ListTile(
                  title: smallLabel(
                      'Ask your mentee to go to Profile Screen, tap on the query to expand, then click on the Reset button at the bottom of the screen to re-upload the query to Browse Screen again. This will cancel the previous session so that you can re-accept the query in order to complete the entire meet-session successfully.',
                      context),
                )
              ],
            ),
            ExpansionTile(
              title: mediumLabel('6. How do I increase my ranking?', context),
              children: [
                ListTile(
                  title: smallLabel(
                      'When you meet up with the mentee, make sure that the mentee gives you a rating at the end of the session. Otherwise, the session is not recorded and the platform cannot recognise that you have mentored someone successfully.',
                      context),
                )
              ],
            ),
            ExpansionTile(
              title: mediumLabel('7. What are the different rankings? ', context),
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          smallLabel('Newcomer', context),
                          smallLabel('Beginner', context),
                          smallLabel('Average', context),
                          smallLabel('Talented', context),
                          smallLabel('Competent', context),
                          smallLabel('Proficient', context),
                          smallLabel('Master', context),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          smallLabel('0-2', context),
                          smallLabel('3-5', context),
                          smallLabel('6-10', context),
                          smallLabel('11-20', context),
                          smallLabel('21-35', context),
                          smallLabel('36-60', context),
                          smallLabel('>60', context),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
