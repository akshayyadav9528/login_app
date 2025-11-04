import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/utilities/dependencies.dart' as dependencies;

class CreateAccountDialog extends StatefulWidget {
  const CreateAccountDialog({super.key});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  RxString status = 'enter-details'.obs;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Widget detailsWidget() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(labelText: 'First Name'),
        ),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(labelText: 'Last Name'),
        ),
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
            if (firstNameController.text.isNotEmpty &&
                lastNameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {
                  status.value = 'creating-account';
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                      'Please fill all the fields',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
            // setState(() {

            // });
            // await Get.find<dependencies.AuthController>().createAccount(
            //   firstNameController.text,
            //   lastNameController.text,
            //   emailController.text,
            //   passwordController.text,
            // );
            // setState(() {
            //   status.value = 'account-created';
            // });
          },
          child: const Text('Create Account'),
        ),
      ],
    );
  }

  Widget creatingAccountWidget() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().createAccount(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error creating account'));
        } else if (snapshot.data == 'success') {
          return const Center(child: Text('Account created successfully'));
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(snapshot.data.toString(), textAlign: TextAlign.center),
                const Text('Error creating account'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      status.value = 'enter-details';
                    });
                  },
                  child: const Text('Try Again'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => status.value == 'enter-details'
              ? detailsWidget()
              : status.value == 'creating-account'
                  ? creatingAccountWidget()
                  : const Center(child: Text('Account created successfully')),
        ),
      ),
    );
  }
}
