import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void sendPushMessage(String token, String title, String body) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAIik8mAg:APA91bHxWYYQtiqIqpDYr_xQ1qX6CXYwcTjtyxABYFR6XMVoGO9XdWh1cAm9DrSIrJzFBAEAlaYPzhzj3GjeO08o6F15h27XqmDUVz8M3RQFaCrjbJmVpkkpRU1HcakGAshXbPrpiH6j',
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'title': title,
            'body': body,
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
          },
          'to': token,
        },
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print('error push notification');
    }
  }
}
