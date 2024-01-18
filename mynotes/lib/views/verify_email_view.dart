import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column(
        children: [
          const Text("We've sent an email verifiction. Please open it to verify your account."),
          const Text("If you haven't receive a verification email yet, press the button below."),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send an email address')),
          TextButton(
            onPressed: () async {
              AuthService.firebase().logOut();
              if(!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false
              );
          },
            child: const Text('Restart'),)
        ],),
    );
  }
}
