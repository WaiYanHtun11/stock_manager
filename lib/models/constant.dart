import 'package:flutter/material.dart';

void goToScreen(BuildContext context,Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => screen
    )
  );
}