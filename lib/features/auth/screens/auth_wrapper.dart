
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../home/home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}

