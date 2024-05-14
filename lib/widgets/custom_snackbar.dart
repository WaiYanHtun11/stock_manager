// Function to show sign-in error snack bar
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context) {
  const snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(24),
    content: Text('Sign in failed. Please try again.'),
    duration: Duration(seconds: 3),
  );

  // Show the snack bar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
