import 'package:flutter/material.dart';

Widget largeLabel(String data, BuildContext context) {
  return Text(
    data,
    style: Theme.of(context).primaryTextTheme.bodyLarge,
  );
}

Widget mediumLabel(String data, BuildContext context) {
  return Text(
    data,
    style: Theme.of(context).primaryTextTheme.bodyMedium,
  );
}

Widget smallLabel(String data, BuildContext context) {
  return Text(
    data,
    style: Theme.of(context).primaryTextTheme.bodySmall,
  );
}
