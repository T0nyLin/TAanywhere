import 'package:flutter/material.dart';

Widget largeLabel(String data, BuildContext context) {
  return Text(
    'Are you sure you want to cancel meet?',
    style: Theme.of(context).primaryTextTheme.bodyLarge,
  );
}

Widget mediumLabel(String data, BuildContext context) {
  return Text(
    data,
    style: Theme.of(context).primaryTextTheme.bodyMedium,
    textAlign: TextAlign.center,
  );
}

Widget smallLabel(String data, BuildContext context) {
  return Text(
    data,
    style: Theme.of(context).primaryTextTheme.bodySmall,
    textAlign: TextAlign.center,
  );
}
