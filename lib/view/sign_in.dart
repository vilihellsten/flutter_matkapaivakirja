/*import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Make sure you have flutterfire_ui package
import 'package:flutterfire_ui/auth.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class SignInScreenWrapper extends StatelessWidget {
  const SignInScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          Get.offAllNamed('/'); // Redirect after account creation
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          Get.offAllNamed('/'); // Redirect after signing in
        }),
      ],
    );
  }
}*/
