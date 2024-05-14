import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stock_manager/providers/auth_provider.dart';
import 'package:stock_manager/screens/home_screen.dart';
import 'package:stock_manager/screens/authentication/sign_in.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(
      builder: (context, authProvider, _) {
        // if (authProvider.user == null && authProvider.isLoading) {
        //   return const Scaffold(
        //     body: Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   );
        // } else
        if (authProvider.user == null) {
          return const SignInScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
