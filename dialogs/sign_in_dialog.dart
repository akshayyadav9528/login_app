import 'package:flutter/material.dart';
import 'package:project/utilities/dependencies.dart' as dependencies;
import 'package:get/get.dart';


class SignInDialog extends StatefulWidget {
  const SignInDialog({super.key});

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  RxString status = 'credentials'.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget Credentialswidget() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text('Sign In', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
        SizedBox(height: 50),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            if (emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {
              status.value = 'signing-in';
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Please fill all the fields'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }

          
          },
          child: const Text('Sign In'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget signingInWidget() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().signIn(
        emailController.text,
        passwordController.text,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Signing In...'),
              ],
            ),
          );
        } else {
          if (snapshot.data == 'success') {
            Future.delayed(const Duration(seconds: 1), () {
              Get.offNamed('/memo_page');
            });
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Signed In Successfully!"),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(snapshot.data.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        status.value = 'credentials';
                      });
                    },
                    child: const Text('Back to Sign In'),
                  ),
                ],
              ),
            );
          }
          // Sign-in successful
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() => status.value == 'credentials'
            ? Credentialswidget()
            : status.value == 'signing-in'
                ? signingInWidget()
                : const Center(child: Text('Unknown state'))
         
        ),
      ),
    );
  }
}
