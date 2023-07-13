import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ta_anywhere/components/auth.dart';

import 'package:ta_anywhere/components/reupload_del.dart';
import 'package:ta_anywhere/screens/editnreupload.dart';
import 'package:ta_anywhere/widget/queryinfo.dart';

uploadtimeconversion(Timestamp lifetime) {
  final DateTime dateConvert =
      DateTime.fromMillisecondsSinceEpoch(lifetime.seconds * 1000);
  DateTime now = DateTime.now();
  var diff = now.difference(dateConvert);
  var upload = diff.inMinutes;

  return upload;
}

lifetimeconversion(Timestamp firstuploadtime) {
  final DateTime dateConvert =
      DateTime.fromMillisecondsSinceEpoch(firstuploadtime.seconds * 1000);
  DateTime now = DateTime.now();
  var diff = now.difference(dateConvert);
  var lifetime = diff.inMinutes;

  return lifetime;
}

Widget itemTile(BuildContext context, Map<String, dynamic> data, int posted) {
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
      onTap: () => showAModalBottomSheet(context, data),
    ),
  );
}

void showeditndeletebuttons(BuildContext context, Map<String, dynamic> data) {
  showModalBottomSheet(
    isDismissible: true,
    backgroundColor: const Color.fromARGB(255, 165, 228, 234),
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(30),
    )),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.18,
      maxChildSize: 0.18,
      minChildSize: 0.18,
      builder: (context, scrollController) => Container(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => EditnReUploadScreen(data: data)));
              },
              icon: Icon(Icons.edit),
              label: Text(
                'Edit',
                style: Theme.of(context).primaryTextTheme.bodyLarge!,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                deleteQuery(data['menteeid']);
                deleteImages(data['image_url']);
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('Query removed successfully'),
                  ));
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              icon: Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ),
              label: Text(
                'Remove Query',
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showAModalBottomSheet(BuildContext context, Map<String, dynamic> data) {
  final User? user = Auth().currentUser;
  showModalBottomSheet(
    isDismissible: true,
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
      builder: (context, scrollController) => Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 5,
            child: Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 115, 111, 111),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: QueryInfoScreen(data: data),
            ),
          ),
          if (user!.uid == data['menteeid'] && data['inSession'] == false)
            Positioned(
              top: 10,
              right: 35,
              child: IconButton(
                  onPressed: () {
                    showeditndeletebuttons(context, data);
                  },
                  icon: Icon(Icons.more_horiz)),
            ),
        ],
      ),
    ),
  );
}
