import 'package:flutter/material.dart';
import 'package:project/utilities/dependencies.dart' as dependencies;
import 'package:get/get.dart';

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            //dependencies.authService.signOut();
            Get.offAllNamed('/login');
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}

