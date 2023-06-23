import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:ta_anywhere/components/pushNotification.dart';
import 'package:ta_anywhere/screens/browse.dart';
import 'package:ta_anywhere/screens/map.dart';
import 'package:ta_anywhere/screens/camera.dart';
import 'package:ta_anywhere/screens/mentor_found.dart';
import 'package:ta_anywhere/screens/paymentNrate.dart';
import 'package:ta_anywhere/screens/profile.dart';
import 'package:ta_anywhere/components/auth.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  PushNotification? _notificationInfo;
  OverlayEntry? entry;
  Offset offset = const Offset(20, 60);
  final User? user = Auth().currentUser;

  void _selectpage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final List<Widget> _screens = [
    const BrowseScreen(),
    const MainMapScreen(),
    const CameraScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    checkForInitialMessage();
    requestPermission();
    super.initState();
  }

  void displose() {
    _showNoti();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 29,
        onTap: _selectpage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search_outlined),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showNoti() {
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            offset += details.delta;
            entry!.markNeedsBuild();
          },
          child: IconButton(
            iconSize: 40,
            color: const Color.fromARGB(255, 194, 68, 51),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          _notificationInfo!.title!,
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                      ),
                      content: Text(_notificationInfo!.body!),
                      actions: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                            entry?.remove();
                            _showNoti();
                          },
                          child: const Text('Dismiss'),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    MentorFound(mentorID: user!.uid)));
                          },
                          child: const Text('Go'),
                        ),
                      ],
                    );
                  });
              entry?.remove();
              entry = null;
            },
            icon: const Icon(Icons.notifications_active_sharp),
          ),
        ),
      ),
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
          );
          showoverlayalert(notification);
        },
      );
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
          );
          showoverlayalert(notification);
        },
      );
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  void showoverlayalert(PushNotification notification) {
    setState(() {
      _notificationInfo = notification;
    });
    if (_notificationInfo != null) {
      showOverlay(
        duration: const Duration(minutes: 5),
        (context, progress) => AlertDialog(
          title: Center(
            child: Text(
              notification.title!,
              style: Theme.of(context).primaryTextTheme.bodyLarge,
            ),
          ),
          content: !notification.title!.startsWith('Well Done!')
              ? Text(notification.body!)
              : null,
          actions: [
            if (notification.title!.startsWith('Congrats,'))
              MaterialButton(
                onPressed: () {
                  OverlaySupportEntry? dismissButton =
                      OverlaySupportEntry.of(context);
                  if (dismissButton != null) {
                    dismissButton.dismiss();
                  }
                  _showNoti();
                },
                child: const Text('Dismiss'),
              ),
            if (notification.title!.startsWith('Congrats,'))
              MaterialButton(
                onPressed: () {
                  OverlaySupportEntry? dismissButton =
                      OverlaySupportEntry.of(context);
                  if (dismissButton != null) {
                    dismissButton.dismiss();
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MentorFound(mentorID: user!.uid)));
                },
                child: const Text('Go'),
              ),
            if (notification.title == 'Oops!')
              MaterialButton(
                onPressed: () {
                  OverlaySupportEntry? dismissButton =
                      OverlaySupportEntry.of(context);
                  if (dismissButton != null) {
                    dismissButton.dismiss();
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => TabsScreen()),
                    (route) => false,
                  );
                  // final route = MaterialPageRoute(
                  //   builder: (context) => const TabsScreen(),
                  // );
                  // Navigator.pushAndRemoveUntil(
                  //     context, route, (route) => false);
                },
                child: const Text('Dismiss'),
              ),
            if (notification.title!.contains('Payment'))
              MaterialButton(
                onPressed: () {
                  OverlaySupportEntry? dismissButton =
                      OverlaySupportEntry.of(context);
                  if (dismissButton != null) {
                    dismissButton.dismiss();
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaymentAndRateScreen(
                            title: notification.title.toString(),
                            mentorID: notification.body.toString(),
                          )));
                },
                child: const Text('Proceed to payment'),
              ),
            if (notification.title!.contains('Free'))
              MaterialButton(
                onPressed: () {
                  OverlaySupportEntry? dismissButton =
                      OverlaySupportEntry.of(context);
                  if (dismissButton != null) {
                    dismissButton.dismiss();
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaymentAndRateScreen(
                            title: notification.title.toString(),
                            mentorID: notification.body.toString(),
                          )));
                },
                child: const Text('Proceed to rate'),
              ),
          ],
        ),
      );
    }
  }
}
