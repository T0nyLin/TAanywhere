import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

DateTime timenow = DateTime.now();

void deleteQuery(String menteeid) {
  FirebaseFirestore.instance
      .collection('user queries')
      .doc(menteeid)
      .delete()
      .then((value) => debugPrint('Query removed.'))
      .catchError((error) => debugPrint('Failed to delete query: $error'));
  ;
}

void deleteImages(String imageurl) async {
  String fileName = imageurl.replaceAll("%2F", "*");
  fileName = fileName.replaceAll("?", "*");
  fileName = fileName.split("*")[1];
  Reference storageReferance = FirebaseStorage.instance.ref();
  try {
    await storageReferance
        .child('query_images')
        .child(fileName)
        .delete()
        .then((_) => debugPrint('Successfully deleted $fileName storage item'));
  } catch (e) {
    debugPrint('$e');
  }
}

void reupload(String menteeid) async {
  await FirebaseFirestore.instance
      .collection('user queries')
      .doc(menteeid)
      .update({
        'inSession': false,
        'lifetime': timenow,
        'uploadedTime': timenow,
        'mentorid': '',
        'mentorToken': '',

      })
      .then((value) => debugPrint('Query reupload.'))
      .catchError((error) => debugPrint('Failed to reupload: $error'));
  ;
}
void updateRating(String mentorID, int rater, double newrating) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(mentorID)
        .update({
      'rater': rater,
      'rating': newrating,
    });
  }