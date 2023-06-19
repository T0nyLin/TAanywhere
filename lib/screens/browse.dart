import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:ta_anywhere/components/pushNotification.dart';
import 'package:ta_anywhere/screens/mentor_found.dart';

import 'package:ta_anywhere/widget/queryinfo.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class _BrowseScreenState extends State<BrowseScreen> {
  PushNotification? _notificationInfo;
  OverlayEntry? entry;
  Offset offset = const Offset(20, 60);
  final User? user = Auth().currentUser;

  @override
  void initState() {
    checkForInitialMessage();
    requestPermission();
    super.initState();
  }

  void displose() {
    _showNoti();
    searchController.dispose();

    super.dispose();
  }

  final queries = FirebaseFirestore.instance.collection('user queries');
  final storageRef = FirebaseStorage.instance.ref();
  TextEditingController searchController = TextEditingController();
  String code = "";

  void _showModalBottomSheet(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      isDismissible: true,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 165, 228, 234),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.8,
        minChildSize: 0.45,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: QueryInfoScreen(data: data),
        ),
      ),
    );
  }

  _uploadtimeconversion(Map<String, dynamic> data) {
    Timestamp lifetime = data['uploadedTime'];
    final DateTime dateConvert =
        DateTime.fromMillisecondsSinceEpoch(lifetime.seconds * 1000);
    DateTime now = DateTime.now();
    var diff = now.difference(dateConvert);
    var upload = diff.inMinutes;

    return upload;
  }

  _lifetimeconversion(Map<String, dynamic> data) {
    Timestamp firstuploadtime = data['lifetime'];
    final DateTime dateConvert =
        DateTime.fromMillisecondsSinceEpoch(firstuploadtime.seconds * 1000);
    DateTime now = DateTime.now();
    var diff = now.difference(dateConvert);
    var lifetime = diff.inMinutes;

    return lifetime;
  }

  _deleteImages(Map<String, dynamic> data) async {
    String fileName = data['image_url'].toString().replaceAll("%2F", "*");
    fileName = fileName.replaceAll("?", "*");
    fileName = fileName.split("*")[1];
    Reference storageReferance = FirebaseStorage.instance.ref();
    try {
      await storageReferance
          .child('query_images')
          .child(fileName)
          .delete()
          .then(
              (_) => debugPrint('Successfully deleted $fileName storage item'));
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> _refreshBrowse() async {
    return await Future.delayed(const Duration(seconds: 1));
  }

  Widget _search(Map<String, dynamic> data, int posted) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () {
              showImageViewer(
                context,
                CachedNetworkImageProvider(data['image_url']),
                swipeDismissible: true,
                doubleTapZoomable: true,
              );
            },
            child: CachedNetworkImage(
              imageUrl: data['image_url'].toString(),
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) =>
                  const CircularProgressIndicator(
                      color: Color.fromARGB(255, 48, 97, 104)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 50,
            ),
          ),
        ),
        title: Text(
          data['query'],
          style: Theme.of(context).primaryTextTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['module Code'],
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                Text(
                  'Cost: ${data['cost']}',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['mentee'],
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                Text(
                  'Posted: $posted min ago',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_right),
        onTap: () => _showModalBottomSheet(context, data),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintStyle: Theme.of(context).primaryTextTheme.bodyMedium,
              hintText: 'Search Module Code',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  searchController.clear();
                  code = "";
                },
                icon: const Icon(Icons.close_rounded),
              )),
          onChanged: (val) {
            setState(() {
              code = val;
            });
          },
        ),
      ),
      body: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 20,
        showChildOpacityTransition: false,
        animSpeedFactor: 2,
        height: 50,
        backgroundColor: const Color.fromARGB(255, 48, 97, 104),
        color: const Color.fromARGB(255, 128, 222, 234),
        onRefresh: _refreshBrowse,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user queries')
              .orderBy('uploadedTime', descending: true)
              .snapshots(),
          builder: (ctx, queriesSnapshots) {
            if (queriesSnapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.waveDots(
                    color: Colors.black, size: 100),
              );
            }
            if (!queriesSnapshots.hasData ||
                queriesSnapshots.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No queries posted.',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              );
            }
            if (queriesSnapshots.hasError) {
              return const Center(
                child: Text('Something went wrong...'),
              );
            }
            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: queriesSnapshots.data!.docs.length,
                    (BuildContext context, int index) {
                      var data = queriesSnapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      var posted = _uploadtimeconversion(data);
                      if (posted >= 10) {
                        queries
                            .doc(queriesSnapshots.data!.docs[index].id
                                .toString())
                            .update({'uploadedTime': DateTime.now()})
                            .then((value) =>
                                debugPrint('Updated uploadTime field'))
                            .catchError((error) =>
                                debugPrint('Failed to update: $error'));
                      }
                      //auto purge after 60min
                      var lifetime = _lifetimeconversion(data);
                      if (lifetime >= 60) {
                        queries
                            .doc(queriesSnapshots.data!.docs[index].id
                                .toString())
                            .delete()
                            .then((value) =>
                                debugPrint('Purged data after 60min'))
                            .catchError((error) =>
                                debugPrint('Failed to delete query: $error'));
                        _deleteImages(data); //del image in FirebaseStorage too
                      }

                      if (code.trim().isEmpty) {
                        return _search(data, lifetime);
                      }
                      if (data['module Code']
                          .toString()
                          .toLowerCase()
                          .contains(code.toLowerCase())) {
                        return _search(data, lifetime);
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
          content: Text(notification.body!),
          actions: [
            MaterialButton(
              onPressed: () {
                _showNoti();
                OverlaySupportEntry? dismissButton =
                    OverlaySupportEntry.of(context);
                if (dismissButton != null) {
                  dismissButton.dismiss();
                }
              },
              child: const Text('Dismiss'),
            ),
            if (notification.title != 'Oops!')
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MentorFound(mentorID: user!.uid)));
                },
                child: const Text('Go'),
              ),
          ],
        ),
      );
    }
  }
}
